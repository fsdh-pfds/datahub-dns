package tflint

import rego.v1

# Deny any resource whose Terraform type doesn’t start with "azurerm_"
deny_non_azure_dns_resource_type contains issue if {
  all := terraform.resources("*", {}, {"expand_mode": "none"})        
  resources := all[_]

  not startswith(resources.type, "azurerm_dns_")

  issue := tflint.issue(
    sprintf("Only Azure DNS resources can be deployed: got %s", [resources.type]),
    resources.decl_range,
  )
}


