


resource "azurerm_private_dns_zone" "weight-tracker-postgresql-db-private-dns-zone" {
  name                = "weight-tracker-db.postgres.database.azure.com"
  resource_group_name = var.rg-name
}

resource "azurerm_private_dns_zone_virtual_network_link" "postgresql-dns-to-vnet-link" {
  name                  = "postgresql-dns-to-vnet-link"
  resource_group_name   = var.rg-name
  private_dns_zone_name = azurerm_private_dns_zone.weight-tracker-postgresql-db-private-dns-zone.name
  virtual_network_id    = var.vnet-id
}

resource "azurerm_postgresql_flexible_server" "weight-tracker-postgresql-db" {
  name                   = "weight-tracker-postgresql-db"
  resource_group_name    = var.rg-name
  location               = var.location
  delegated_subnet_id    = var.private-subnet-id
  private_dns_zone_id    = azurerm_private_dns_zone.weight-tracker-postgresql-db-private-dns-zone.id
  administrator_login    = "postgres"
  administrator_password = var.postgresql-db-password
  version                = 12
  zone                   = "3"

  storage_mb = 32768

  sku_name = "B_Standard_B1ms"

  depends_on = [azurerm_private_dns_zone_virtual_network_link.postgresql-dns-to-vnet-link]

}



resource "azurerm_postgresql_flexible_server_configuration" "psql-set-certification-off" {
  name      = "require_secure_transport"
  server_id = azurerm_postgresql_flexible_server.weight-tracker-postgresql-db.id
  value     = "off"
}

