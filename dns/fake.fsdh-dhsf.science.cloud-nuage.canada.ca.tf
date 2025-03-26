resource "azurerm_dns_zone" "fake_fsdh-dhsf_science_cloud-nuage_canada_ca-zone" {
  name                = "fake.fsdh-dhsf.science.cloud-nuage.canada.ca"
  resource_group_name = var.resource_group_name
}

resource "azurerm_dns_a_record" "fake_fsdh-dhsf_science_cloud-nuage_canada_ca-a-at" {
  name                = "@"
  zone_name           = azurerm_dns_zone.zone.name
  resource_group_name = var.resource_group_name
  ttl                 = 3600
  records             = ["20.48.202.171"]
}

resource "azurerm_dns_a_record" "fake_fsdh-dhsf_science_cloud-nuage_canada_ca-prd" {
  name                = "prd"
  zone_name           = azurerm_dns_zone.zone.name
  resource_group_name = var.resource_group_name
  ttl                 = 3600
  records             = ["20.175.249.169"]
}

resource "azurerm_dns_a_record" "fake_fsdh-dhsf_science_cloud-nuage_canada_ca-pre" {
  name                = "pre"
  zone_name           = azurerm_dns_zone.zone.name
  resource_group_name = var.resource_group_name
  ttl                 = 60
  records             = ["20.175.249.169"]

}

resource "azurerm_dns_cname_record" "fake_fsdh-dhsf_science_cloud-nuage_canada_ca-bisjsr_app" {
  name                = "bisjsr-app"
  zone_name           = azurerm_dns_zone.zone.name
  resource_group_name = var.resource_group_name
  ttl                 = 900
  record              = "fsdh-proj-bisjsr-poc.azurewebsites.net"
}

resource "azurerm_dns_cname_record" "fake_fsdh-dhsf_science_cloud-nuage_canada_ca-dev" {
  name                = "dev"
  zone_name           = azurerm_dns_zone.zone.name
  resource_group_name = var.resource_group_name
  ttl                 = 120
  record              = "fsdh-portal-app-dev.azurewebsites.net"
}

resource "azurerm_dns_cname_record" "fake_fsdh-dhsf_science_cloud-nuage_canada_ca-dsw" {
  name                = "dsw"
  zone_name           = azurerm_dns_zone.zone.name
  resource_group_name = var.resource_group_name
  ttl                 = 3600
  record              = "fsdh-dsw-dev.azurewebsites.net"
}

resource "azurerm_dns_cname_record" "fake_fsdh-dhsf_science_cloud-nuage_canada_ca-int" {
  name                = "int"
  zone_name           = azurerm_dns_zone.zone.name
  resource_group_name = var.resource_group_name
  ttl                 = 120
  record              = "fsdh-portal-app-int.azurewebsites.net"
}

resource "azurerm_dns_cname_record" "fake_fsdh-dhsf_science_cloud-nuage_canada_ca-ncco_app" {
  name                = "ncco-app"
  zone_name           = azurerm_dns_zone.zone.name
  resource_group_name = var.resource_group_name
  ttl                 = 900
  record              = "fsdh-proj-ncco-webapp-poc.azurewebsites.net"
}

resource "azurerm_dns_cname_record" "fake_fsdh-dhsf_science_cloud-nuage_canada_ca-poc" {
  name                = "poc"
  zone_name           = azurerm_dns_zone.zone.name
  resource_group_name = var.resource_group_name
  ttl                 = 120
  record              = "fsdh-portal-app-poc.azurewebsites.net"
}

resource "azurerm_dns_ns_record" "fake_fsdh-dhsf_science_cloud-nuage_canada_ca-ns-at" {
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
