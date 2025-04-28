resource "azurerm_dns_zone" "private_zone" {
  name                = "private.example.com"
  resource_group_name = var.resource_group_name
  zone_type           = "Private"
}