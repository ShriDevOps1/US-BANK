# ============================================================
# Root module — orchestrates sub-modules based on infra_type
# ============================================================

locals {
  deploy_vnet    = contains(["vnet", "aks", "all"], var.infra_type)
  deploy_acr     = contains(["acr", "all"], var.infra_type)
  deploy_aks     = contains(["aks", "all"], var.infra_type)
  deploy_storage = contains(["storage", "all"], var.infra_type)

  name_prefix = "${var.project}-${var.environment}"

  common_tags = merge(
    {
      environment = var.environment
      project     = var.project
      managed_by  = "terraform"
      deployed_by = "gitlab-ci"
    },
    var.tags
  )
}

# ── Resource Group ───────────────────────────────────────────
resource "azurerm_resource_group" "main" {
  name     = "rg-${local.name_prefix}"
  location = var.location
  tags     = local.common_tags
}

# ── VNet ─────────────────────────────────────────────────────
module "vnet" {
  count  = local.deploy_vnet ? 1 : 0
  source = "./modules/vnet"

  name_prefix        = local.name_prefix
  resource_group     = azurerm_resource_group.main.name
  location           = var.location
  vnet_address_space = var.vnet_address_space
  aks_subnet_cidr    = var.aks_subnet_cidr
  pod_subnet_cidr    = var.pod_subnet_cidr
  tags               = local.common_tags
}

# ── ACR ──────────────────────────────────────────────────────
module "acr" {
  count  = local.deploy_acr ? 1 : 0
  source = "./modules/acr"

  name_prefix    = local.name_prefix
  resource_group = azurerm_resource_group.main.name
  location       = var.location
  sku            = var.acr_sku
  admin_enabled  = var.acr_admin_enabled
  tags           = local.common_tags
}

# ── AKS ──────────────────────────────────────────────────────
module "aks" {
  count  = local.deploy_aks ? 1 : 0
  source = "./modules/aks"

  name_prefix        = local.name_prefix
  resource_group     = azurerm_resource_group.main.name
  location           = var.location
  kubernetes_version = var.aks_kubernetes_version
  node_count         = var.aks_node_count
  min_node_count     = var.aks_min_node_count
  max_node_count     = var.aks_max_node_count
  vm_size            = var.aks_vm_size
  os_disk_size_gb    = var.aks_os_disk_size_gb
  aks_subnet_id      = local.deploy_vnet ? module.vnet[0].aks_subnet_id : null
  pod_subnet_id      = local.deploy_vnet ? module.vnet[0].pod_subnet_id : null
  acr_id             = local.deploy_acr ? module.acr[0].acr_id : null
  tags               = local.common_tags

  depends_on = [module.vnet, module.acr]
}

# ── Storage (tfstate / app blobs) ────────────────────────────
module "storage" {
  count  = local.deploy_storage ? 1 : 0
  source = "./modules/storage"

  name_prefix    = local.name_prefix
  resource_group = azurerm_resource_group.main.name
  location       = var.location
  tags           = local.common_tags
}
