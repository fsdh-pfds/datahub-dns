#!/bin/bash
# Run this script to deploy the infrastructure needed for the DNS zone management solution.

usage() {
	echo "Usage: $0 [-g resource_group] [-a storage_account] [-c container_name] [-l location] [-u subscription_id] [-k backend_key] [-i managed_identity]"
	exit 1
}

# Initialize default values
RESOURCE_GROUP=""
STORAGE_ACCOUNT=""
CONTAINER_NAME=""
LOCATION="Canada Central"
SUBSCRIPTION_ID=""
BACKEND_KEY="dns.tfstate"
MANAGED_IDENTITY=""

# Parse command-line arguments
while getopts ":g:a:c:l:u:k:i:" opt; do
	case ${opt} in
	g)
		RESOURCE_GROUP=$OPTARG
		;;
	a)
		STORAGE_ACCOUNT=$OPTARG
		;;
	c)
		CONTAINER_NAME=$OPTARG
		;;
	l)
		LOCATION=$OPTARG
		;;
	u)
		SUBSCRIPTION_ID=$OPTARG
		;;
	k)
		BACKEND_KEY=$OPTARG
		;;
	i)
		MANAGED_IDENTITY=$OPTARG
		;;
	\?)
		echo "Invalid option: -$OPTARG" 1>&2
		usage
		;;
	:)
		echo "Option -$OPTARG requires an argument." 1>&2
		usage
		;;
	esac
done
shift $((OPTIND - 1))

# Prompt for values if not provided via command-line
if [ -z "$RESOURCE_GROUP" ]; then
	read -p -r "Enter Resource Group Name [dns-resource-group]: " RESOURCE_GROUP
	RESOURCE_GROUP=${RESOURCE_GROUP:-dns-resource-group}
fi

if [ -z "$STORAGE_ACCOUNT" ]; then
	read -p -r "Enter Storage Account Name (must be globally unique) [yourtfstatestorage]: " STORAGE_ACCOUNT
	STORAGE_ACCOUNT=${STORAGE_ACCOUNT:-yourtfstatestorage}
fi

if [ -z "$CONTAINER_NAME" ]; then
	read -p -r "Enter Blob Container Name [tfstate]: " CONTAINER_NAME
	CONTAINER_NAME=${CONTAINER_NAME:-tfstate}
fi

if [ -z "$LOCATION" ]; then
	read -p -r "Enter Azure Location [Canada Central]: " LOCATION
	LOCATION=${LOCATION:-"Canada Central"}
fi

if [ -z "$SUBSCRIPTION_ID" ]; then
	read -p -r "Enter Subscription ID (leave blank to use the current subscription): " SUBSCRIPTION_ID
	if [ -z "$SUBSCRIPTION_ID" ]; then
		SUBSCRIPTION_ID=$(az account show --query id -o tsv)
	fi
fi

if [ -z "$MANAGED_IDENTITY" ]; then
	read -p -r "Enter Managed Identity Name [dns-identity]: " MANAGED_IDENTITY
	MANAGED_IDENTITY=${MANAGED_IDENTITY:-dns-identity}
fi

# Switch to the desired subscription
echo "Switching to subscription: $SUBSCRIPTION_ID"
az account set --subscription "$SUBSCRIPTION_ID"

# Retrieve the tenant ID from the current Azure account
TENANT_ID=$(az account show --query tenantId -o tsv)

echo "Creating Resource Group '$RESOURCE_GROUP' in location '$LOCATION'..."
az group create --name "$RESOURCE_GROUP" --location "$LOCATION"

echo "Creating Storage Account '$STORAGE_ACCOUNT' in Resource Group '$RESOURCE_GROUP'..."
az storage account create \
	--name "$STORAGE_ACCOUNT" \
	--resource-group "$RESOURCE_GROUP" \
	--location "$LOCATION" \
	--sku Standard_LRS \
	--kind StorageV2 \
	--allow-blob-public-access false

echo "Creating Blob Container '$CONTAINER_NAME' in Storage Account '$STORAGE_ACCOUNT'..."
az storage container create \
	--name "$CONTAINER_NAME" \
	--account-name "$STORAGE_ACCOUNT" \
	--public-access off \
	--auth-mode login

echo "Creating Managed Identity '$MANAGED_IDENTITY' in Resource Group '$RESOURCE_GROUP'..."
az identity create --name "$MANAGED_IDENTITY" --resource-group "$RESOURCE_GROUP" --location "$LOCATION" >/dev/null
MANAGED_IDENTITY_PRINCIPAL=$(az identity show --name "$MANAGED_IDENTITY" --resource-group "$RESOURCE_GROUP" --query "principalId" -o tsv)

echo "Assigning 'Storage Blob Data Contributor' role to Managed Identity on Blob Container..."
CONTAINER_SCOPE="/subscriptions/$SUBSCRIPTION_ID/resourceGroups/$RESOURCE_GROUP/providers/Microsoft.Storage/storageAccounts/$STORAGE_ACCOUNT/blobServices/default/containers/$CONTAINER_NAME"
az role assignment create --assignee "$MANAGED_IDENTITY_PRINCIPAL" --role "Storage Blob Data Contributor" --scope "$CONTAINER_SCOPE"

echo "Assigning 'DNS Zone Contributor' role to Managed Identity on Resource Group..."
RG_SCOPE="/subscriptions/$SUBSCRIPTION_ID/resourceGroups/$RESOURCE_GROUP"
az role assignment create --assignee "$MANAGED_IDENTITY_PRINCIPAL" --role "DNS Zone Contributor" --scope "$RG_SCOPE"

echo "Deployment complete: Resource group, storage account, container, and managed identity have been created."

# Output JSON configuration for ADO pipelines
JSON_OUTPUT=$(
	cat <<EOF
{
  "resource_group_name": "$RESOURCE_GROUP",
  "location": "$LOCATION",
  "storage_account_name": "$STORAGE_ACCOUNT",
  "container_name": "$CONTAINER_NAME",
  "backend_key": "$BACKEND_KEY",
  "subscription_id": "$SUBSCRIPTION_ID",
  "tenant_id": "$TENANT_ID",
  "managed_identity": "$MANAGED_IDENTITY",
  "managed_identity_principal": "$MANAGED_IDENTITY_PRINCIPAL"
}
EOF
)

echo -e "\nADO Pipeline Configuration JSON:"
echo "$JSON_OUTPUT"
