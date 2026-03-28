variable "resource_group_name" {
  description = "Name of the Azure resource group"
  type        = string
  default     = "rg-demo-postgres"
}

variable "location" {
  description = "Azure region for all resources"
  type        = string
  default     = "eastus"
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "postgres_server_name" {
  description = "Name of the PostgreSQL Flexible Server (must be globally unique)"
  type        = string
  default     = "psql-demo-server"
}

variable "postgres_version" {
  description = "PostgreSQL major version"
  type        = string
  default     = "16"
}

variable "postgres_sku_name" {
  description = "SKU for the PostgreSQL Flexible Server"
  type        = string
  default     = "B_Standard_B1ms" # Burstable 1 vCore — use GP_Standard_D2s_v3 for prod
}

variable "postgres_storage_mb" {
  description = "Storage size in MB (32768 = 32 GB)"
  type        = number
  default     = 32768
}

variable "postgres_admin_username" {
  description = "Administrator login name"
  type        = string
  default     = "psqladmin"
}

variable "postgres_admin_password" {
  description = "Administrator password (stored in Key Vault in prod)"
  type        = string
  sensitive   = true
}

variable "postgres_database_name" {
  description = "Name of the initial database"
  type        = string
  default     = "appdb"
}

variable "allowed_ip_start" {
  description = "Start IP for firewall rule allowing external access (set to app subnet in prod)"
  type        = string
  default     = "0.0.0.0"
}

variable "allowed_ip_end" {
  description = "End IP for firewall rule"
  type        = string
  default     = "0.0.0.0"
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default = {
    project     = "demo"
    managed_by  = "terraform"
  }
}
