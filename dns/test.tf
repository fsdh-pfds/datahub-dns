# sds.alpha.canada.ca.tf
resource "azurerm_dns_zone" "test_alpha_canada_ca_zone" {
  name                = "test.alpha.canada.ca"
  resource_group_name = var.resource_group_name
  lifecycle {
    ignore_changes = [tags]
  }
}