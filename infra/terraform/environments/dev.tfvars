# ── Dev environment ───────────────────────────────────────────
environment = "dev"
location    = "eastus"
project     = "usbank"

# Networking
vnet_address_space = ["10.0.0.0/16"]
aks_subnet_cidr    = "10.0.1.0/24"
pod_subnet_cidr    = "10.0.2.0/23"

# AKS — smaller for dev
aks_node_count         = 1
aks_min_node_count     = 1
aks_max_node_count     = 3
aks_vm_size            = "Standard_D2s_v3"
aks_kubernetes_version = null   # latest stable
aks_os_disk_size_gb    = 30

# ACR
acr_sku           = "Basic"
acr_admin_enabled = true

tags = {
  team        = "platform"
  cost_center = "eng-dev"
}
