package tflint

import rego.v1

# 1. Grab all your DNS zones (no type‐hint needed if you’re just
#    inspecting meta-args)
zones := terraform.resources("azurerm_dns_zone", {}, {"expand_mode":"none"})

# 2. Helper: did the resource define a lifecycle.ignore_changes = ["tags"]?
has_ignore_tags(config) {
  # There must be a lifecycle block…
  lifecycle := config.lifecycle

  # …and that block’s .value.ignore_changes must include the literal "tags"
  lifecycle.value.ignore_changes.value[_] == "tags"
}

# 3. If a zone is missing that exact setting, emit an issue
deny_missing_ignore_tags contains issue {
  zone := zones[i]

  # Fail when:
  #  - no lifecycle block, OR
  #  - lifecycle.ignore_changes doesn’t include "tags"
  not has_ignore_tags(zone.config)

  issue := tflint.issue(
    "azurerm_dns_zone must set lifecycle.ignore_changes = [\"tags\"]",
    zone.decl_range
  )
}
