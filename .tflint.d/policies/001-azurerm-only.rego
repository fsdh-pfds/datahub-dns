package tflint

import rego.v1

# Deny any resource whose Terraform type doesn’t start with "azurerm_"
deny_non_azurerm_resource_type contains issue if {
  all := terraform.resources("*", {}, {"expand_mode": "none"})        
  resources := all[_]

  not startswith(resources.type, "azurerm_")

  issue := tflint.issue(
    sprintf("Only AzureRM resources can be deployed: got %s", [resources.type]),
    resources.decl_range,
  )
}


