package tflint

import rego.v1

# Mock an invalid AzureRM resource to confirm no issues are raised
failed_resources(type, schema, options) := terraform.mock_resources(type, schema, options, {
  "main.tf": `
    resource "aws_instance" "dummy-aws-instance" {
      instance_type = "t2.micro"  
    }
  `}
)

# Mock a valid AzureRM resource to confirm no issues are raised
passing_resources(type, schema, options) := terraform.mock_resources(type, schema, options, {
  "main.tf": `
    resource "azurerm_dns_zone" "dummy-dns-zone" {
      name                = "example.com"
      resource_group_name = "my-rg"
    }
  `}
)

test_deny_resource_declarations_failed if {
	issues := deny_non_azurerm_resource_type with terraform.resources as failed_resources

	count(issues) == 1
	issue := issues[_]
	issue.msg == "Only AzureRM resources can be deployed: got aws_instance"
}

test_deny_resource_declarations_pass if {
  issues := deny_non_azurerm_resource_type
    with terraform.resources as passing_resources

  count(issues) == 0
}