output "resource_group_name" {
  description = "Resource group that holds all deployed resources"
  value       = azurerm_resource_group.main.name
}

# ── VNet ─────────────────────────────────────────────────────
output "vnet_id" {
  description = "VNet resource ID"
  value       = length(module.vnet) > 0 ? module.vnet[0].vnet_id : null
}

output "aks_subnet_id" {
  description = "AKS node subnet ID"
  value       = length(module.vnet) > 0 ? module.vnet[0].aks_subnet_id : null
}

# ── ACR ──────────────────────────────────────────────────────
output "acr_login_server" {
  description = "ACR login server URL"
  value       = length(module.acr) > 0 ? module.acr[0].login_server : null
}

output "acr_id" {
  description = "ACR resource ID"
  value       = length(module.acr) > 0 ? module.acr[0].acr_id : null
}

# ── AKS ──────────────────────────────────────────────────────
output "aks_cluster_name" {
  description = "AKS cluster name"
  value       = length(module.aks) > 0 ? module.aks[0].cluster_name : null
}

output "aks_cluster_id" {
  description = "AKS cluster resource ID"
  value       = length(module.aks) > 0 ? module.aks[0].cluster_id : null
}

output "kube_config" {
  description = "Raw kubeconfig — use to connect kubectl"
  value       = length(module.aks) > 0 ? module.aks[0].kube_config : null
  sensitive   = true
}

output "aks_oidc_issuer_url" {
  description = "AKS OIDC issuer URL (for Workload Identity)"
  value       = length(module.aks) > 0 ? module.aks[0].oidc_issuer_url : null
}
