//bainer.ca.tf
resource "azurerm_dns_zone" "bainer_ca_zone" {
  name                = "bainer.ca"
  resource_group_name = var.resource_group_name
}

locals {
  zone_name = azurerm_dns_zone.bainer_ca_zone.name
}

resource "azurerm_dns_a_record" "bainer_ca_www" {
  name                = "www"
  zone_name           = local.zone_name
  resource_group_name = var.resource_group_name
  ttl                 = 3600
  records             = ["1.2.3.4"]
}

resource "azurerm_dns_cname_record" "bainer_ca_blog" {
  name                = "blog"
  zone_name           = local.zone_name
  resource_group_name = var.resource_group_name
  ttl                 = 3600
  record              = "bainer.github.io"
}
