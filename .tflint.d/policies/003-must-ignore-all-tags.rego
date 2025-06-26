package tflint

import tflint
import terraform

# Deny any resource block missing lifecycle.ignore_changes = [..., "tags", ...]
deny_missing_ignore_tags contains issue if {
  res := terraform.resources("*", {}, {"expand_mode": "all"})[_]

  lc := res.blocks["lifecycle"]

  not lc 
  or not lc.attributes["ignore_changes"]
  or not tag_in_ignore(lc.attributes["ignore_changes"].expr.values)

  issue := tflint.issue(
    sprintf(
      "Resource %s.%s must ignore changes to tags via lifecycle.ignore_changes",
      [res.type, res.name],
    ),
    res.decl_range,
  )
}

# helper: does the list of values include the literal "tags"?
tag_in_ignore(vals) {
  some i
  vals[i] == "tags"
}
