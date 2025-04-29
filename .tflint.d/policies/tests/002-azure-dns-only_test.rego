package tflint
import rego.v1

# Mock a non-Azure DNS resource to confirm issues are raised
failed_dns_resources(type, schema, options) := terraform.mock_resources(type, schema, options, {
  "main.tf": `
    resource "azurerm_resource_group" "rg" {
      name     = "example-resource-group"
      location = "Canada Central"
    }
  `}
)

# Mock a valid azure dns resource to confirm no issues are raised
passing_dns_resources(type, schema, options) := terraform.mock_resources(type, schema, options, {
  "main.tf": `
    resource "azurerm_dns_zone" "dummy-dns-zone" {
      name                = "example.com"
      resource_group_name = "my-rg"
    }
  `}
)

test_deny_resource_declarations_failed if {
	issues := deny_non_azure_dns_resource_type with terraform.resources as failed_dns_resources
	count(issues) == 1
	issue := issues[_]
	issue.msg == "Only Azure DNS resources can be deployed: got azurerm_resource_group"
}

test_deny_resource_declarations_pass if {
  issues := deny_non_azure_dns_resource_type with terraform.resources as passing_dns_resources
  count(issues) == 0
}