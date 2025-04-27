package terrascan.azure.dns.allowed_resources

__rego_metadata__ := {
  "id": "AC_AZURE_DNS_0001",
  "version": "1.0"
}

# Define your whitelist
allowed := {
  "azurerm_dns_zone",
  "azurerm_dns_a_record",
  "azurerm_dns_cname_record",
}

# Terrascan will evaluate this rule for each resource block in your HCL
deny[msg] {
  # `input.resource_type` is the Terraform type string, e.g. "azurerm_dns_zone"
  input.resource_type
  not allowed[input.resource_type]
  msg := sprintf("Resource type %q is not permitted in this DNS repo", [input.resource_type])
}
