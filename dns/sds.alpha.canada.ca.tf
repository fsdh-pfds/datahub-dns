# sds.alpha.canada.ca.tf
resource "azurerm_dns_zone" "sds_alpha_canada_ca_zone" {
  name                = "sds.alpha.canada.ca"
  resource_group_name = var.resource_group_name
}

resource "azurerm_dns_cname_record" "redirection_sds_alpha_canada_ca_cname" {
  name                = "redirection"
  zone_name           = "sds.alpha.canada.ca"
  resource_group_name = var.resource_group_name
  ttl                 = 300
  record              = "fsdh-pfds.github.io"
}