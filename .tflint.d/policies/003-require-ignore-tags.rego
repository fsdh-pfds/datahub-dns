package tflint

import rego.v1

deny_require_lifecycle_ignore_tags contains issue if {
  res := terraform.resources("*",{"lifecycle": {"ignore_changes": "expr"}},{"expand_mode": "none"},)[_]

  res.config.lifecycle[_]

  not has_tags_ignore(res)

  issue := tflint.issue(
    sprintf(
      "Resource %s.%s must include \"tags\" in lifecycle.ignore_changes",
      [res.type, res.name],
    ),
    res.decl_range,
  )
}

has_tags_ignore(res) if {
  lifeblock := res.config.lifecycle[_]
  ic        := lifeblock.config.ignore_changes

  some i
  trim(hcl.expr_list(ic)[i].value, "\"") == "tags"
}
