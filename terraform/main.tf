# ─────────────────────────────────────────────
# Resource Group
# ─────────────────────────────────────────────
resource "azurerm_resource_group" "this" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

# ─────────────────────────────────────────────
# Random suffix to help ensure global uniqueness
# ─────────────────────────────────────────────
resource "random_string" "suffix" {
  length  = 6
  upper   = false
  special = false
}

# ─────────────────────────────────────────────
# PostgreSQL Flexible Server
# ─────────────────────────────────────────────
resource "azurerm_postgresql_flexible_server" "this" {
  name                   = "${var.postgres_server_name}-${random_string.suffix.result}"
  resource_group_name    = azurerm_resource_group.this.name
  location               = azurerm_resource_group.this.location
  version                = var.postgres_version
  administrator_login    = var.postgres_admin_username
  administrator_password = var.postgres_admin_password

  sku_name   = var.postgres_sku_name
  storage_mb = var.postgres_storage_mb

  # Geo-redundant backup — set to Enabled for prod
  geo_redundant_backup_enabled  = false
  backup_retention_days         = 7

  # Set to ZoneRedundant for HA in prod
  high_availability {
    mode = "Disabled"
  }

  maintenance_window {
    day_of_week  = 0 # Sunday
    start_hour   = 2
    start_minute = 0
  }

  tags = merge(var.tags, { environment = var.environment })
}

# ─────────────────────────────────────────────
# Database
# ─────────────────────────────────────────────
resource "azurerm_postgresql_flexible_server_database" "app" {
  name      = var.postgres_database_name
  server_id = azurerm_postgresql_flexible_server.this.id
  collation = "en_US.utf8"
  charset   = "UTF8"
}

# ─────────────────────────────────────────────
# Firewall Rules
# ─────────────────────────────────────────────

# Allow Azure services (e.g., App Service, AKS) — start/end both 0.0.0.0
resource "azurerm_postgresql_flexible_server_firewall_rule" "allow_azure_services" {
  name             = "allow-azure-services"
  server_id        = azurerm_postgresql_flexible_server.this.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}

# Optional: allow a specific IP range (e.g., VPN, office)
resource "azurerm_postgresql_flexible_server_firewall_rule" "allow_custom_range" {
  name             = "allow-custom-ip-range"
  server_id        = azurerm_postgresql_flexible_server.this.id
  start_ip_address = var.allowed_ip_start
  end_ip_address   = var.allowed_ip_end
}

# ─────────────────────────────────────────────
# Server Configuration (postgresql.conf params)
# ─────────────────────────────────────────────
resource "azurerm_postgresql_flexible_server_configuration" "require_ssl" {
  name      = "require_secure_transport"
  server_id = azurerm_postgresql_flexible_server.this.id
  value     = "on"
}

resource "azurerm_postgresql_flexible_server_configuration" "log_connections" {
  name      = "log_connections"
  server_id = azurerm_postgresql_flexible_server.this.id
  value     = "on"
}
