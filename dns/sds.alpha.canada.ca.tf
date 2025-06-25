# sds.alpha.canada.ca.tf
resource "azurerm_dns_zone" "sds_alpha_canada_ca_zone" {
  name                = "sds.alpha.canada.ca"
  resource_group_name = var.resource_group_name
}