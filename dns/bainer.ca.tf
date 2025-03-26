resource "azurerm_dns_zone" "bainer_ca-zone" {
  name                = "bainer.ca"
  resource_group_name = var.resource_group_name
}

resource "azurerm_dns_a_record" "bainer_ca-www" {
  name                = "www"
  zone_name           = azurerm_dns_zone.zone.name
  resource_group_name = var.resource_group_name
  ttl                 = 3600
  records             = ["1.2.3.4"]
}

resource "azurerm_dns_cname_record" "bainer_ca-blog" {
  name                = "blog"
  zone_name           = azurerm_dns_zone.zone.name
  resource_group_name = var.resource_group_name
  ttl                 = 3600
  record              = "bainer.github.io"
}





