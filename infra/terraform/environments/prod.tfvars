# ── Production environment ─────────────────────────────────────
environment = "prod"
location    = "eastus"
project     = "usbank"

vnet_address_space = ["10.2.0.0/16"]
aks_subnet_cidr    = "10.2.1.0/24"
pod_subnet_cidr    = "10.2.2.0/23"

aks_node_count         = 3
aks_min_node_count     = 2
aks_max_node_count     = 10
aks_vm_size            = "Standard_D4s_v3"
aks_kubernetes_version = null
aks_os_disk_size_gb    = 100

acr_sku           = "Premium"
acr_admin_enabled = false

tags = {
  team        = "platform"
  cost_center = "eng-prod"
  criticality = "high"
}
