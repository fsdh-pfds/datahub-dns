package tflint
import rego.v1

# Get all Azure resources (since your original rule was Azure-specific)
azure_resources := terraform.resources("azurerm_*", {}, {"expand_mode": "none"})

# Check if resource is missing lifecycle.ignore_changes = [tags]
is_missing_lifecycle_ignore_tags(resource) if {
    # lifecycle block doesn't exist
    not "lifecycle" in object.keys(resource)
}

is_missing_lifecycle_ignore_tags(resource) if {
    # lifecycle exists but ignore_changes doesn't
    "lifecycle" in object.keys(resource)
    not "ignore_changes" in object.keys(resource.lifecycle)
}

is_missing_lifecycle_ignore_tags(resource) if {
    # lifecycle and ignore_changes exist but "tags" is not in the list
    "lifecycle" in object.keys(resource)
    "ignore_changes" in object.keys(resource.lifecycle)
    not "tags" in resource.lifecycle.ignore_changes
}

# Rule for missing lifecycle ignore tags
deny_missing_lifecycle_ignore_tags contains issue if {
    is_missing_lifecycle_ignore_tags(azure_resources[i])
    issue := tflint.issue(
        sprintf("Resource %s must have lifecycle block with ignore_changes = [tags]", [azure_resources[i].type]),
        azure_resources[i].decl_range
    )
}