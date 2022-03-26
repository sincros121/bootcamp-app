


output "psql-fqdn" {
  value = azurerm_postgresql_flexible_server.weight-tracker-postgresql-db.fqdn
}

#output "psql-conenction" {
#  value = azurerm_postgresql_flexible_server.weight-tracker-postgresql-db.connection
#}