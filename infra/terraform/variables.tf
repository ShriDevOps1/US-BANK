# ── Core ─────────────────────────────────────────────────────
variable "environment" {
  description = "Deployment environment: dev | staging | prod"
  type        = string
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "environment must be dev, staging, or prod."
  }
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "eastus"
}

variable "project" {
  description = "Project/application name — used in resource naming"
  type        = string
  default     = "usbank"
}

# ── Infra selector ───────────────────────────────────────────
variable "infra_type" {
  description = "Which infra components to deploy: aks | acr | vnet | storage | all"
  type        = string
  default     = "all"
  validation {
    condition     = contains(["aks", "acr", "vnet", "storage", "all"], var.infra_type)
    error_message = "infra_type must be one of: aks, acr, vnet, storage, all."
  }
}

# ── Networking ───────────────────────────────────────────────
variable "vnet_address_space" {
  description = "VNet CIDR block"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "aks_subnet_cidr" {
  description = "AKS node subnet CIDR"
  type        = string
  default     = "10.0.1.0/24"
}

variable "pod_subnet_cidr" {
  description = "AKS pod subnet CIDR (Azure CNI)"
  type        = string
  default     = "10.0.2.0/23"
}

# ── AKS ──────────────────────────────────────────────────────
variable "aks_node_count" {
  description = "Default node count per node pool"
  type        = number
  default     = 2
}

variable "aks_min_node_count" {
  description = "Minimum node count for autoscaler"
  type        = number
  default     = 1
}

variable "aks_max_node_count" {
  description = "Maximum node count for autoscaler"
  type        = number
  default     = 5
}

variable "aks_vm_size" {
  description = "AKS node VM SKU"
  type        = string
  default     = "Standard_D2s_v3"
}

variable "aks_kubernetes_version" {
  description = "Kubernetes version (leave null for latest stable)"
  type        = string
  default     = null
}

variable "aks_os_disk_size_gb" {
  description = "OS disk size in GB for AKS nodes"
  type        = number
  default     = 50
}

# ── ACR ──────────────────────────────────────────────────────
variable "acr_sku" {
  description = "ACR SKU: Basic | Standard | Premium"
  type        = string
  default     = "Standard"
}

variable "acr_admin_enabled" {
  description = "Enable ACR admin user"
  type        = bool
  default     = false
}

# ── Tags ─────────────────────────────────────────────────────
variable "tags" {
  description = "Additional tags to apply to all resources"
  type        = map(string)
  default     = {}
}
