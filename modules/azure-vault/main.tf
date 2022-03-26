
locals {
  key-vault-id = data.azurerm_key_vault.azure-vault.id
}


#Fetching all necessary passwords and secrets for this application and it's infrastructure from azure vault.
data "azurerm_key_vault" "azure-vault" {
  name                = var.azure-vault-name
  resource_group_name = var.azure-vault-resource-group
}

data "azurerm_key_vault_secret" "vm-password" {
  key_vault_id = local.key-vault-id
  name         = "VM-password"
}

data "azurerm_key_vault_secret" "cookie-encrypt-pwd" {
  key_vault_id = local.key-vault-id
  name         = "cookie-encrypt-pwd"
}

data "azurerm_key_vault_secret" "okta-client-secret" {
  key_vault_id = local.key-vault-id
  name         = "okta-client-secret"
}

data "azurerm_key_vault_secret" "weight-tacker-PSQL-password" {
  key_vault_id = local.key-vault-id
  name         = "weight-tracker-PSQL-password"
}

data "azurerm_key_vault_secret" "okta-API-token" {
  key_vault_id = local.key-vault-id
  name         = "OKTA-api-token"
}
