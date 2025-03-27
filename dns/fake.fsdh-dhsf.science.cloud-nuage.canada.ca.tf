# fake.fsdh-dhsf.science.cloud-nuage.canada.ca.tf
resource "azurerm_dns_zone" "fake_fsdh_dhsf_science_cloud_nuage_canada_ca_zone" {
  name                = "fake.fsdh-dhsf.science.cloud-nuage.canada.ca"
  resource_group_name = var.resource_group_name
}

locals {
  zone_name = azurerm_dns_zone.fake_fsdh_dhsf_science_cloud_nuage_canada_ca_zone.name
}

resource "azurerm_dns_a_record" "fake_fsdh_dhsf_science_cloud_nuage_canada_ca_a_at" {
  name                = "@"
  zone_name           = local.zone_name
  resource_group_name = var.resource_group_name
  ttl                 = 3600
  records             = ["20.48.202.171"]
}

resource "azurerm_dns_a_record" "fake_fsdh_dhsf_science_cloud_nuage_canada_ca_prd" {
  name                = "prd"
  zone_name           = local.zone_name
  resource_group_name = var.resource_group_name
  ttl                 = 3600
  records             = ["20.175.249.169"]
}

resource "azurerm_dns_a_record" "fake_fsdh_dhsf_science_cloud_nuage_canada_ca_pre" {
  name                = "pre"
  zone_name           = local.zone_name
  resource_group_name = var.resource_group_name
  ttl                 = 60
  records             = ["20.175.249.169"]

}
