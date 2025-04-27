package terrascan.terraform.dns_module_whitelist

__rego_metadata__ := {
  "id": "AC_AZURE_DNS_0002",
  "version": "1.0"
}

# Allowed module source paths
allowed_modules := {"./dns"}

deny[msg] {
  # Terrascan exposes module calls via `input.module_calls`
  call := input.module_calls[_]
  not allowed_modules[call.source]
  msg := sprintf("Module source %q is not on the approved list", [call.source])
}
