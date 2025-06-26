package tflint
import rego.v1

# Deny resources that don't have lifecycle.ignore_changes containing "tags"
deny_missing_lifecycle_ignore_tags contains issue if {
    all := terraform.resources("*", {}, {"expand_mode": "all"})
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