terraform {
  backend "azurerm" {
    # comment out 'use_azuread_auth' line to run locally
    #use_azuread_auth     = true
    resource_group_name  = var.resource_group_name
    storage_account_name = var.storage_account_name
    container_name       = var.container_name
    key                  = var.backend_state_name
  }
}

module "dns" {
  source              = "./dns"
  resource_group_name = var.resource_group_name
}

provider "azurerm" {
  features {}

  # OIDC authentication for GitHub Actions
  use_oidc        = true
  client_id       = var.azure_client_id
  tenant_id       = var.azure_tenant_id
  subscription_id = var.azure_subscription_id
}