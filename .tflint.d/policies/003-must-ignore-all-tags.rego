package tflint

import terraform
import tflint

# Deny any resource that does not explicitly ignore changes to tags.
deny_missing_ignore_tags contains issue if {
  # Iterate all resources, with block expansion so we can see nested lifecycle blocks
  res := terraform.resources("*", {}, {"expand_mode": "all"})[_]

  # If the resource is NOT ignoring tags, emit an issue
  not is_ignoring_tags(res)

  issue := tflint.issue(
    sprintf("Resource %s.%s must include lifecycle.ignore_changes = [\"tags\"]", [res.type, res.name]),
    res.decl_range,
  )
}

# Helper: returns true if the resource has lifecycle.ignore_changes containing "tags"
is_ignoring_tags(res) {
  lc := res.blocks["lifecycle"]
  # lifecycle block must exist
  lc

  # must have an ignore_changes attribute
  ic := lc.attributes["ignore_changes"]
  ic

  # and one of its list values must be the literal "tags"
  some i
  ic.expr.values[i] == "tags"
}
