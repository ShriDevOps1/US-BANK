# ── Staging environment ────────────────────────────────────────
environment = "staging"
location    = "eastus"
project     = "usbank"

vnet_address_space = ["10.1.0.0/16"]
aks_subnet_cidr    = "10.1.1.0/24"
pod_subnet_cidr    = "10.1.2.0/23"

aks_node_count         = 2
aks_min_node_count     = 1
aks_max_node_count     = 4
aks_vm_size            = "Standard_D2s_v3"
aks_kubernetes_version = null
aks_os_disk_size_gb    = 50

acr_sku           = "Standard"
acr_admin_enabled = false

tags = {
  team        = "platform"
  cost_center = "eng-staging"
}
