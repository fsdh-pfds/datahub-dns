variable "azure_client_id" {
  description = "The Client ID of the Managed Identity"
  type        = string
  sensitive   = true
}

variable "azure_tenant_id" {
  description = "The Tenant ID of the Azure AD tenant"
  type        = string
  sensitive   = true
}

variable "azure_subscription_id" {
  description = "The Subscription ID for the Azure account"
  type        = string
  sensitive   = true
}

variable "resource_group_name" {
  description = "The resource group for the DNS zone and backend"
  type        = string
  sensitive   = true
}

variable "storage_account_name" {
  description = "The Storage Account Name for the backend"
  type        = string
  sensitive   = true
}

variable "container_name" {
  description = "The Container Name for the backend"
  type        = string
  sensitive   = true
}

variable "backend_state_name" {
  description = "The name for the backend state file"
  type        = string
  sensitive   = true
}
