terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.0"
    }
  }

  backend "azurerm" {
    use_azuread_auth      = true
    resource_group_name   = "${var.resource_group_name}"
    storage_account_name  = "${var.storage_account_name}"
    container_name        = "${var.container_name}"
    key                   = "${var.backend_state_name}"
  }
}

provider "azurerm" {
  features {}

  # Use Managed Identity with OIDC
  use_msi              = true
  client_id            = "${var.azure_client_id}"  # Will come from environment variable or secrets
  tenant_id            = "${var.azure_tenant_id}"  # Will come from environment variable or secrets
  subscription_id      = "${var.azure_subscription_id}"  # Will come from environment variable or secrets
}

# Variables to allow passing these values
variable "azure_client_id" {
  description = "The Client ID of the Managed Identity"
  type        = string
}

variable "azure_tenant_id" {
  description = "The Tenant ID of the Azure AD tenant"
  type        = string
}

variable "azure_subscription_id" {
  description = "The Subscription ID for the Azure account"
  type        = string
}
