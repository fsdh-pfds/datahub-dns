# Azure Terraform Backend Deployment Script

This script automates the creation of an Azure Resource Group, Storage Account, and Blob Container that serve as the Terraform backend for managing DNS records. Additionally, it outputs a JSON configuration string containing all the necessary values (including subscription and tenant IDs) for configuring your Azure DevOps (ADO) pipelines.

## Overview

The script performs the following tasks:
- Prompts for or accepts via command-line arguments the required parameters:
  - **Resource Group Name**
  - **Storage Account Name** (must be globally unique)
  - **Blob Container Name**
  - **Azure Location** (defaults to "Canada Central")
  - **Subscription ID** (optional; auto-fetches if not provided)
  - **Backend Key** (defaults to "dns.tfstate")
- Creates the specified Resource Group.
- Creates a Storage Account and Blob Container within that Resource Group.
- Retrieves the current subscription and tenant IDs.
- Outputs a JSON string with the configuration details needed for your ADO pipelines.

## Prerequisites

- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli) must be installed and authenticated.
- An active Azure subscription with the necessary permissions.
- Optionally, [Terraform](https://www.terraform.io/downloads.html) installed if you plan to use the generated backend configuration.

## Usage

You can run the script interactively to be prompted for values, or you can pass the parameters as command-line arguments.

### Command-Line Options

- `-g`: Resource Group Name (default: `dns-resource-group`)
- `-a`: Storage Account Name (must be globally unique; default: `yourtfstatestorage`)
- `-c`: Blob Container Name (default: `tfstate`)
- `-l`: Azure Location (default: `Canada Central`)
- `-u`: Subscription ID (if omitted, the script will auto-fetch it)
- `-k`: Backend Key (default: `dns.tfstate`)

### Example

Run the script with all parameters provided:
```bash
./deploy-backend.sh -g my-dns-rg -a mystorageacct -c mycontainer -l "Canada Central" -u 00000000-0000-0000-0000-000000000000 -k mybackend.tfstate
```

If you omit any parameters, the script will prompt you to enter them.

## Output

Once the resources are created, the script outputs a JSON string with the configuration details. An example output is:

```json
{
  "resource_group_name": "my-dns-rg",
  "location": "Canada Central",
  "storage_account_name": "mystorageacct",
  "container_name": "mycontainer",
  "backend_key": "mybackend.tfstate",
  "subscription_id": "00000000-0000-0000-0000-000000000000",
  "tenant_id": "11111111-1111-1111-1111-111111111111"
}
```

This JSON can be used directly in your ADO pipeline configuration for initializing the Terraform backend.
