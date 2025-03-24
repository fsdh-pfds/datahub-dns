#!/bin/bash

# Prompt for values with defaults
read -p "Enter Resource Group Name [dns-resource-group]: " RESOURCE_GROUP
RESOURCE_GROUP=${RESOURCE_GROUP:-dns-resource-group}

read -p "Enter Storage Account Name (must be globally unique) [yourtfstatestorage]: " STORAGE_ACCOUNT
STORAGE_ACCOUNT=${STORAGE_ACCOUNT:-yourtfstatestorage}

read -p "Enter Blob Container Name [tfstate]: " CONTAINER_NAME
CONTAINER_NAME=${CONTAINER_NAME:-tfstate}

read -p "Enter Azure Location [Canada Central]: " LOCATION
LOCATION=${LOCATION:-"Canada Central"}

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
  --public-access off

echo "Deployment complete: Resource group, storage account, and container have been created."

# Output JSON configuration for ADO pipelines
JSON_OUTPUT=$(cat <<EOF
{
  "resource_group_name": "$RESOURCE_GROUP",
  "location": "$LOCATION",
  "storage_account_name": "$STORAGE_ACCOUNT",
  "container_name": "$CONTAINER_NAME",
  "backend_key": "terraform.tfstate"
}
EOF
)

echo -e "\nADO Pipeline Configuration JSON:"
echo "$JSON_OUTPUT"
