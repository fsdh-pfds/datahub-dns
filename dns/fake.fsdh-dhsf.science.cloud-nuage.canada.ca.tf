resource "azurerm_dns_zone" "zone" {
  name                = "fake.fsdh-dhsf.science.cloud-nuage.canada.ca"
  resource_group_name = var.resource_group_name
}

resource "azurerm_dns_a_record" "at" {
  name                = "@"
  zone_name           = azurerm_dns_zone.zone.name
  resource_group_name = var.resource_group_name
  ttl                 = 3600
  records             = ["20.48.202.171"]
}

resource "azurerm_dns_a_record" "prd" {
  name                = "prd"
  zone_name           = azurerm_dns_zone.zone.name
  resource_group_name = var.resource_group_name
  ttl                 = 3600
  records             = ["20.175.249.169"]
}

resource "azurerm_dns_a_record" "pre" {
  name                = "pre"
  zone_name           = azurerm_dns_zone.zone.name
  resource_group_name = var.resource_group_name
  ttl                 = 60
  records             = ["20.175.249.169"]

}

resource "azurerm_dns_cname_record" "bisjsr_app" {
  name                = "bisjsr-app"
  zone_name           = azurerm_dns_zone.zone.name
  resource_group_name = var.resource_group_name
  ttl                 = 900
  record              = "fsdh-proj-bisjsr-poc.azurewebsites.net"
}

resource "azurerm_dns_cname_record" "dev" {
  name                = "dev"
  zone_name           = azurerm_dns_zone.zone.name
  resource_group_name = var.resource_group_name
  ttl                 = 120
  record              = "fsdh-portal-app-dev.azurewebsites.net"
}

resource "azurerm_dns_cname_record" "dsw" {
  name                = "dsw"
  zone_name           = azurerm_dns_zone.zone.name
  resource_group_name = var.resource_group_name
  ttl                 = 3600
  record              = "fsdh-dsw-dev.azurewebsites.net"
}

resource "azurerm_dns_cname_record" "int" {
  name                = "int"
  zone_name           = azurerm_dns_zone.zone.name
  resource_group_name = var.resource_group_name
  ttl                 = 120
  record              = "fsdh-portal-app-int.azurewebsites.net"
}

resource "azurerm_dns_cname_record" "ncco_app" {
  name                = "ncco-app"
  zone_name           = azurerm_dns_zone.zone.name
  resource_group_name = var.resource_group_name
  ttl                 = 900
  record              = "fsdh-proj-ncco-webapp-poc.azurewebsites.net"
}

resource "azurerm_dns_cname_record" "poc" {
  name                = "poc"
  zone_name           = azurerm_dns_zone.zone.name
  resource_group_name = var.resource_group_name
  ttl                 = 120
  record              = "fsdh-portal-app-poc.azurewebsites.net"
}

resource "azurerm_dns_ns_record" "at" {
  name                = "@"
  zone_name           = azurerm_dns_zone.zone.name
  resource_group_name = var.resource_group_name
  ttl                 = 172800
  records = [
    "ns1-33.azure-dns.com.",
    "ns2-33.azure-dns.net.",
    "ns3-33.azure-dns.org.",
    "ns4-33.azure-dns.info."
  ]
}
