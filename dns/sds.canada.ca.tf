# sds.canada.ca.tf

resource "azurerm_dns_zone" "sds_canada_ca_zone" {
  name                = "sds.canada.ca"
  resource_group_name = var.resource_group_name

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_dns_a_record" "sds_canada_ca_a_record" {
  name                = "@"
  zone_name           = azurerm_dns_zone.sds_canada_ca_zone.name
  resource_group_name = var.resource_group_name
  ttl                 = 3600
  records = [
    "185.199.108.153",
    "185.199.109.153",
    "185.199.110.153",
    "185.199.111.153"
  ]

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_dns_txt_record" "sds_canada_ca_txt_github_pages_challenge_record" {
  name                = "_github-pages-challenge-fsdh-pfds"
  zone_name           = azurerm_dns_zone.sds_canada_ca_zone.name
  resource_group_name = var.resource_group_name
  ttl                 = 3600
  record {
    value = "5910da3f935f005ba8fa51eaca6495"
  }

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_dns_cname_record" "sds_canada_ca_cname_www" {
  name                = "www"
  zone_name           = azurerm_dns_zone.sds_canada_ca_zone.name
  resource_group_name = var.resource_group_name
  ttl                 = 3600
  record              = "sds.canada.ca"

  lifecycle {
    ignore_changes = [tags]
  }
}