package tflint

import rego.v1

deny_require_lifecycle_ignore_tags contains issue if {
  res := terraform.resources("*",{"lifecycle": {"ignore_changes": "list(string)"}},{"expand_mode": "expand"})[_]
  not has_tags_ignore(res)

  issue := tflint.issue(
    sprintf("Resource %s.%s must have lifecycle.ignore_changes include \"tags\"", [res.type, res.name]),
    res.decl_range
  )
}

# helper succeeds only if there's a lifecycle.ignore_changes list and one of its elements == "tags"
has_tags_ignore(res) if {
  lifeblock := res.config.lifecycle[_]

  ic := lifeblock.config.ignore_changes

  some i
  ic.value[i] == "tags"
}
