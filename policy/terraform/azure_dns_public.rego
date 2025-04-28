package azure

# Deny any DNS zone explicitly configured as Private
deny[msg] {
  zone := input.azurerm_dns_zone[_]
  zone.config.zone_type == "Private"
  msg := sprintf("DNS zone '%v' is private; only public DNS zones are allowed", [zone.config.name])
}