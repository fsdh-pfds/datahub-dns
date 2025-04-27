package terraform.whitelist.resources

# Only allow these azure DNS-related resource types
allowed_resources := {
  "azurerm_dns_zone",
  "azurerm_dns_a_record",
  "azurerm_dns_cname_record",
}

deny[msg] {
  change := input.resource_changes[_]
  change.type
  not allowed_resources[change.type]
  msg := sprintf("❌ Resource type %q is not permitted in this repo", [change.type])
}
