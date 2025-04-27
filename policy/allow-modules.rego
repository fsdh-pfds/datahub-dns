package terraform.whitelist.modules

# Only allow calls to your in-repo dns module
allowed_modules := {
  "./dns",
}

deny[msg] {
  call := input.module_calls[_]
  not allowed_modules[call.source]
  msg := sprintf("❌ Module source %q is not on the approved list", [call.source])
}
