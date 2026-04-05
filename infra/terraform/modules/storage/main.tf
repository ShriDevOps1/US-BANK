resource "azurerm_storage_account" "main" {
  # Storage account names: 3-24 lowercase alphanumeric only
  name                     = substr(replace("st${var.name_prefix}", "-", ""), 0, 24)
  resource_group_name      = var.resource_group
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  min_tls_version          = "TLS1_2"
  tags                     = var.tags
}

resource "azurerm_storage_container" "app_data" {
  name                  = "app-data"
  storage_account_name  = azurerm_storage_account.main.name
  container_access_type = "private"
}
