output "postgres_server_fqdn" {
  description = "Fully qualified domain name of the PostgreSQL server"
  value       = azurerm_postgresql_flexible_server.this.fqdn
}

output "postgres_server_name" {
  description = "Name of the PostgreSQL Flexible Server"
  value       = azurerm_postgresql_flexible_server.this.name
}

output "postgres_database_name" {
  description = "Name of the created database"
  value       = azurerm_postgresql_flexible_server_database.app.name
}

output "postgres_connection_string" {
  description = "JDBC connection string for Spring Boot"
  value       = "jdbc:postgresql://${azurerm_postgresql_flexible_server.this.fqdn}:5432/${var.postgres_database_name}?sslmode=require"
  sensitive   = false
}

output "resource_group_name" {
  description = "Resource group containing all resources"
  value       = azurerm_resource_group.this.name
}
