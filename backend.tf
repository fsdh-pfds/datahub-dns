terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.0"  # You can specify a version range or a fixed version
    }
  }

  backend "azurerm" {
    # Your backend configuration here
    use_azuread_auth = true
    resource_group_name   = "${var.resource_group_name}"
    storage_account_name  = "${var.storage_account_name}"
    container_name        = "${var.container_name}"
    key                   = "${var.backend_state_name}"
  }
}

provider "azurerm" {
  features {}
}
