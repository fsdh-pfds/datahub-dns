terraform {
  required_version = ">= 1.10"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.24, < 4.25"
    }
  }

  backend "azurerm" {
    //comment out 'use_azuread_auth' line to run locally
    use_azuread_auth     = true
    resource_group_name  = var.resource_group_name
    storage_account_name = var.storage_account_name
    container_name       = var.container_name
    key                  = var.backend_state_name
  }
}

module "dns" {
  source              = "./dns"
  resource_group_name = var.resource_group_name
  # pass other variables as needed
}

provider "azurerm" {
  features {}

  # OIDC authentication for GitHub Actions
  use_oidc        = true
  client_id       = var.azure_client_id
  tenant_id       = var.azure_tenant_id
  subscription_id = var.azure_subscription_id
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

variable "storage_account_name" {
  description = "The Storage Account Name for the backend"
  type        = string
}

variable "container_name" {
  description = "The Container Name for the backend"
  type        = string
}

variable "backend_state_name" {
  description = "The name for the backend state file"
  type        = string
}
