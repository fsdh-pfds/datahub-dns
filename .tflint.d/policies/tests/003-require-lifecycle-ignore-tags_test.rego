package tflint

import rego.v1

# Mock for a resource missing lifecycle.ignore_changes entirely
no_lifecycle(type, schema, options) := terraform.mock_resources(type, schema, options, {
  "main.tf": `
resource "azurerm_dns_zone" "no_lifecycle" {
  name                = "example.com"
  resource_group_name = "my-rg"
}
`
})

# Mock for a resource that has lifecycle but no ignore_changes
no_ignore_changes(type, schema, options) := terraform.mock_resources(type, schema, options, {
  "main.tf": `
resource "azurerm_dns_zone" "no_ignore" {
  name                = "example.com"
  resource_group_name = "my-rg"
  lifecycle { }
}
`
})

# Mock for a resource whose ignore_changes is wrong
wrong_ignore(type, schema, options) := terraform.mock_resources(type, schema, options, {
  "main.tf": `
resource "azurerm_dns_zone" "wrong_ignore" {
  name                = "example.com"
  resource_group_name = "my-rg"
  lifecycle {
    ignore_changes = ["name"]
  }
}
`
})

# Mock for a perfectly valid resource
correct_ignore(type, schema, options) := terraform.mock_resources(type, schema, options, {
  "main.tf": `
resource "azurerm_dns_zone" "correct_ignore" {
  name                = "example.com"
  resource_group_name = "my-rg"
  lifecycle {
    ignore_changes = ["tags"]
  }
}
`
})

# 1) missing lifecycle should error
test_missing_lifecycle if {
  issues := deny_require_lifecycle_ignore_tags
    with terraform.resources as no_lifecycle

  count(issues) == 1
  issues[_].msg == "Resource azurerm_dns_zone.no_lifecycle must have lifecycle.ignore_changes include \"tags\""
}

# 2) lifecycle but no ignore_changes
test_missing_ignore_changes if {
  issues := deny_require_lifecycle_ignore_tags
    with terraform.resources as no_ignore_changes

  count(issues) == 1
  issues[_].msg == "Resource azurerm_dns_zone.no_ignore must have lifecycle.ignore_changes include \"tags\""
}

# 3) wrong ignore_changes
test_wrong_ignore if {
  issues := deny_require_lifecycle_ignore_tags
    with terraform.resources as wrong_ignore

  count(issues) == 1
  issues[_].msg == "Resource azurerm_dns_zone.wrong_ignore must have lifecycle.ignore_changes include \"tags\""
}

# 4) correct ignore_changes passes
test_correct_ignore if {
  issues := deny_require_lifecycle_ignore_tags
    with terraform.resources as correct_ignore

  count(issues) == 0
}
