terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.7"  # Minimum for OIDC support
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

  # OIDC authentication for GitHub Actions
  use_oidc        = true
  client_id       = var.azure_client_id
  tenant_id       = var.azure_tenant_id
  subscription_id = var.azure gece_subscription_id
}

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

variable "resource_group_name" {
  description = "The resource group for the DNS zone and backend"
  type        = string
}
