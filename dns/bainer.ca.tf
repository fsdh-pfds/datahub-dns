provider "azurerm" {
  features {}
}

variable "resource_group_name" {
  description = "The resource group where the DNS zone is located"
  type        = string
}

//make changes below this line

resource "azurerm_dns_zone" "zone" {
  name                = "bainer.ca"
  resource_group_name = var.resource_group_name
}

resource "azurerm_dns_a_record" "www" {
  name                = "www"
  zone_name           = azurerm_dns_zone.zone.name
  resource_group_name = var.resource_group_name
  ttl                 = 3600
  records             = ["1.2.3.4"]
}

resource "azurerm_dns_cname_record" "blog" {
  name                = "blog"
  zone_name           = azurerm_dns_zone.zone.name
  resource_group_name = var.resource_group_name
  ttl                 = 3600
  record              = "bainer.github.io"
}
