resource "azurerm_kubernetes_cluster" "main" {
  name                = "aks-${var.name_prefix}"
  location            = var.location
  resource_group_name = var.resource_group
  dns_prefix          = "${var.name_prefix}-aks"
  kubernetes_version  = var.kubernetes_version

  # System node pool
  default_node_pool {
    name                = "system"
    node_count          = var.node_count
    vm_size             = var.vm_size
    os_disk_size_gb     = var.os_disk_size_gb
    vnet_subnet_id      = var.aks_subnet_id
    pod_subnet_id       = var.pod_subnet_id
    enable_auto_scaling = true
    min_count           = var.min_node_count
    max_count           = var.max_node_count

    upgrade_settings {
      max_surge = "10%"
    }
  }

  # Managed identity — no service principal needed
  identity {
    type = "SystemAssigned"
  }

  # Networking
  network_profile {
    network_plugin    = var.aks_subnet_id != null ? "azure" : "kubenet"
    network_policy    = "azure"
    load_balancer_sku = "standard"
    outbound_type     = "loadBalancer"
  }

  # OIDC + Workload Identity
  oidc_issuer_enabled       = true
  workload_identity_enabled = true

  # Azure Monitor
  oms_agent {
    log_analytics_workspace_id = azurerm_log_analytics_workspace.main.id
  }

  # Azure Policy add-on
  azure_policy_enabled = true

  # HTTP application routing disabled — use ingress-nginx instead
  http_application_routing_enabled = false

  key_vault_secrets_provider {
    secret_rotation_enabled = true
  }

  tags = var.tags
}

# ── Log Analytics Workspace ───────────────────────────────────
resource "azurerm_log_analytics_workspace" "main" {
  name                = "law-${var.name_prefix}"
  location            = var.location
  resource_group_name = var.resource_group
  sku                 = "PerGB2018"
  retention_in_days   = 30
  tags                = var.tags
}

# ── Attach ACR to AKS (pull permission) ──────────────────────
resource "azurerm_role_assignment" "aks_acr_pull" {
  count                = var.acr_id != null ? 1 : 0
  principal_id         = azurerm_kubernetes_cluster.main.kubelet_identity[0].object_id
  role_definition_name = "AcrPull"
  scope                = var.acr_id
}

# ── User node pool (workload nodes) ──────────────────────────
resource "azurerm_kubernetes_cluster_node_pool" "workload" {
  name                  = "workload"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.main.id
  vm_size               = var.vm_size
  node_count            = var.node_count
  enable_auto_scaling   = true
  min_count             = var.min_node_count
  max_count             = var.max_node_count
  vnet_subnet_id        = var.aks_subnet_id
  pod_subnet_id         = var.pod_subnet_id
  os_disk_size_gb       = var.os_disk_size_gb

  node_labels = {
    "workload-type" = "general"
  }

  upgrade_settings {
    max_surge = "33%"
  }

  tags = var.tags
}
