terraform {
  backend "azurerm" {
    use_azuread_auth = true
    source  = "hashicorp/azurerm"
    version = "~> 2.0"
  }
}
