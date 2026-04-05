resource "azurerm_container_registry" "main" {
  # ACR names: 5-50 alphanumeric chars, globally unique
  name                = replace("acr${var.name_prefix}", "-", "")
  resource_group_name = var.resource_group
  location            = var.location
  sku                 = var.sku
  admin_enabled       = var.admin_enabled

  dynamic "georeplications" {
    for_each = var.sku == "Premium" ? var.geo_replication_locations : []
    content {
      location                = georeplications.value
      zone_redundancy_enabled = true
    }
  }

  tags = var.tags
}
