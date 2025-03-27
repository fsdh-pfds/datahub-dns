variable "azure_client_id" {
  description = "The Client ID of the Managed Identity"
  type        = string
}

variable "azure_tenant_id" {
  description = "The Tenant ID of the Azure AD tenant"
  type        = string
}

variable "azure_subscription_id" {
  description = "The Subscription ID for the Azure account"
  type        = string
}

variable "resource_group_name" {
  description = "The resource group for the DNS zone and backend"
  type        = string
}

variable "storage_account_name" {
  description = "The Storage Account Name for the backend"
  type        = string
}

variable "container_name" {
  description = "The Container Name for the backend"
  type        = string
}

variable "backend_state_name" {
  description = "The name for the backend state file"
  type        = string
}
