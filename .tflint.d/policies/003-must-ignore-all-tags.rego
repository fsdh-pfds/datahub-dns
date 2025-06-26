package tflint
import rego.v1

# Debug rule to understand the structure
debug_resource_structure contains issue if {
    all := terraform.resources("*", {}, {})
    resources := all[_]
    
    issue := tflint.issue(
        sprintf("DEBUG: Resource %s has config: %v", [resources.type, resources.config]),
        resources.decl_range,
    )
}

# Debug rule to check if lifecycle exists at all
debug_lifecycle_check contains issue if {
    all := terraform.resources("*", {}, {})
    resources := all[_]
    resources.config.lifecycle
    
    issue := tflint.issue(
        sprintf("DEBUG: Found lifecycle in %s: %v", [resources.type, resources.config.lifecycle]),
        resources.decl_range,
    )
}

# Deny resources that don't have lifecycle.ignore_changes containing "tags"
deny_missing_lifecycle_ignore_tags contains issue if {
    all := terraform.resources("*", {}, {})
    resources := all[_]
    
    # Check all conditions that would make this resource non-compliant
    not _has_lifecycle_ignore_tags(resources)
    
    issue := tflint.issue(
        sprintf("Resource %s must have lifecycle block with ignore_changes = [tags]", [resources.type]),
        resources.decl_range,
    )
}

# Helper function to check if resource has proper lifecycle.ignore_changes = [tags]
_has_lifecycle_ignore_tags(resource) if {
    # Check if lifecycle exists and has ignore_changes with "tags"
    lifecycle := resource.config.lifecycle
    lifecycle[_].ignore_changes
    "tags" in lifecycle[_].ignore_changes
}