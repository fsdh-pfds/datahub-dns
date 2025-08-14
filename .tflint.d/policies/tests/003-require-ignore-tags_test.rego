package tflint

import rego.v1

failed_lifecycle_ignore_tags(type, _, _) := terraform.mock_resources(type,{"lifecycle": {"ignore_changes": "expr"}},{"expand_mode": "none"},{
    "main.tf": `
      resource "aws_instance" "bad" {
        lifecycle {
          ignore_changes = ["foo", "bar"]
        }
      }
    `}
)

passing_lifecycle_ignore_tags(type, _, _) := terraform.mock_resources(type,{"lifecycle": {"ignore_changes": "expr"}},{"expand_mode": "none"},{
    "main.tf": `
      resource "aws_instance" "good" {
        lifecycle {
          ignore_changes = ["foo", "tags", "bar"]
        }
      }
    `}
)

dynamic_lifecycle_ignore_tags(type, _, _) := terraform.mock_resources(type,{"lifecycle": {"ignore_changes": "expr"}},{"expand_mode": "none"},{
    "main.tf": `
      resource "aws_instance" "also_good" {
        lifecycle {
          ignore_changes = [foo_key, tags, var.other]
        }
      }
    `}
)

no_lifecycle(type, _, _) := terraform.mock_resources(type,{"lifecycle": {"ignore_changes": "expr"}},{"expand_mode": "none"},{
    "main.tf": `
      resource "aws_instance" "none" {
        # no lifecycle block
        tags = { Environment = "dev" }
      }
    `}
)


test_require_lifecycle_ignore_tags_failed if {
  issues := [ i |
    i = deny_require_lifecycle_ignore_tags[_]
      with terraform.resources as failed_lifecycle_ignore_tags
  ]
  count(issues) == 1
  issues[0].msg == "Resource aws_instance.bad must include \"tags\" in lifecycle.ignore_changes"
}

test_require_lifecycle_ignore_tags_pass_literal if {
  issues := [ i |
    i = deny_require_lifecycle_ignore_tags[_]
      with terraform.resources as passing_lifecycle_ignore_tags
  ]
  count(issues) == 0
}

test_require_lifecycle_ignore_tags_pass_dynamic if {
  issues := [ i |
    i = deny_require_lifecycle_ignore_tags[_]
      with terraform.resources as dynamic_lifecycle_ignore_tags
  ]
  count(issues) == 0
}

test_require_lifecycle_ignore_tags_no_lifecycle if {
  issues := [ i |
    i = deny_require_lifecycle_ignore_tags[_]
      with terraform.resources as no_lifecycle
  ]
  count(issues) == 0
}
