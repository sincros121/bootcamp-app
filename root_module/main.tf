
locals {
  #Default resource location that will be used for the resource group and all the resources in it.
  def-location = azurerm_resource_group.resourceGroup.location

  #Default resource group that will be used for all created resources in the project.
  rg-name = azurerm_resource_group.resourceGroup.name

  #The
  load-balancer-public-ip = azurerm_public_ip.load-balancer-public-ip.ip_address

  key-vault-id = data.azurerm_key_vault.azure-vault.id
}


#Fetching all necessary passwords and secrets for this application and it's infrastructure from azure vault.
data "azurerm_key_vault" "azure-vault" {
  name                = "staslevman-vault"
  resource_group_name = "Vault-rg"
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



resource "azurerm_resource_group" "resourceGroup" {
  name     = "weight-tracker-rg"
  location = "East US"
}


module "network-security-groups" {
  source           = "../modules/network-security-groups"
  public-nsg-name  = "public-nsg"
  private-nsg-name = "private-nsg"
  location         = local.def-location
  rg-name          = local.rg-name
#  user-IP-for-SSH  = module.network-security-groups.ip
}


resource "azurerm_virtual_network" "vnet" {
  name                = "weight-tracker-vnet"
  location            = local.def-location
  resource_group_name = local.rg-name
  address_space       = ["10.0.0.0/22"]
}

module "subnets" {
  source    = "../modules/subnets"
  rg-name   = local.rg-name
  vnet-name = azurerm_virtual_network.vnet.name
}


resource "azurerm_subnet_network_security_group_association" "associate-public-SCG" {
  subnet_id                 = module.subnets.public-subnet-id
  network_security_group_id = module.network-security-groups.public-scg-id
}

resource "azurerm_subnet_network_security_group_association" "associate-private-SCG" {
  subnet_id                 = module.subnets.private-subnet-id
  network_security_group_id = module.network-security-groups.private-scg-id
}

resource "azurerm_public_ip" "load-balancer-public-ip" {
  name                = "front-public-ip"
  resource_group_name = local.rg-name
  location            = local.def-location
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "application-VM-NIC" {
  location            = local.def-location
  name                = "application-VM-NIC"
  resource_group_name = local.rg-name
  ip_configuration {
    name                          = "internal"
    subnet_id                     = module.subnets.public-subnet-id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.load-balancer-public-ip.id
  }
}

data "template_file" "custom-data-shell-script" {
  template = file("${path.module}/VM-startup-script-template.sh")
 #             ${file("${path.module}/VM-startup-script-template.sh")}"

  vars = {

    okta-API-token = data.azurerm_key_vault_secret.okta-API-token.value
    PGHOST = ""
    PGPASSWORD = data.azurerm_key_vault_secret.weight-tacker-PSQL-password.value
    HOST_URL_IP = local.load-balancer-public-ip #Used both for the .env population and to update okta URI's
    COOKIE_ENCRYPT_PWD = data.azurerm_key_vault_secret.cookie-encrypt-pwd.value
    OKTA_CLIENT_SECRET = data.azurerm_key_vault_secret.okta-client-secret.value
  }
}


module "application-VM" {
  source             = "../modules/virtual-machine"
  VM-amount          = "1"
  VM-username        = "ubuntu"
  VM-name            = "web-application-VM"
  location           = local.def-location
  rg-name            = local.rg-name
  application-NIC-id = azurerm_network_interface.application-VM-NIC.id
  admin-password     = data.azurerm_key_vault_secret.vm-password.value
  VM-custom-data     = base64encode("${data.template_file.custom-data-shell-script.rendered}")
}



resource "azurerm_lb" "front-load-balancer" {
  name                = "front-load-balancer"
  location            = local.def-location
  resource_group_name = local.rg-name
  sku = "Standard"

  frontend_ip_configuration {
    name                 = "front-lb-ip-config"
    public_ip_address_id = azurerm_public_ip.load-balancer-public-ip.id
  }
}


