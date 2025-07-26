plugin "azurerm" {
    enabled = true
    version = "0.28.0"
    source  = "github.com/terraform-linters/tflint-ruleset-azurerm"
}

plugin "opa" {
  enabled = true
  version = "0.9.0"
  source  = "github.com/terraform-linters/tflint-ruleset-opa"
}

rule "terraform_comment_syntax" {
  enabled = true
}

rule "terraform_unused_declarations" {
  enabled = true
}

rule "terraform_documented_variables" {
  enabled = true
}

rule "terraform_typed_variables" {
  enabled = true
}

rule "terraform_naming_convention" {
  enabled = true
}

// single shared version file is used 
rule "terraform_required_version" {
  enabled = false
}

// single shared required providers
rule "terraform_required_providers" {
  enabled = false
}

// disabled for simplicity of dns zone structure
rule "terraform_standard_module_structure" {
  enabled = false
}