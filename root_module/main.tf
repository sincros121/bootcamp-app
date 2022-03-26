
locals {
  #Default resource location that will be used for the resource group and all the resources in it.
  def-location = azurerm_resource_group.resource-group.location

  #Default resource group that will be used for all created resources in the project.
  rg-name = azurerm_resource_group.resource-group.name

  #The
  load-balancer-public-ip-address = azurerm_public_ip.load-balancer-public-ip.ip_address

  vmss-maximum-instances = 10

  inbound-nat-port-start = 50101
}


module "azure-vault" {
  source = "../modules/azure-vault"

  azure-vault-name           = "staslevman-vault"
  azure-vault-resource-group = "Vault-rg"
}


resource "azurerm_resource_group" "resource-group" {
  name     = "weight-tracker-rg"
  location = "East US"
}


module "network-security-groups" {
  source = "../modules/network-security-groups"

  public-nsg-name  = "public-nsg"
  private-nsg-name = "private-nsg"
  location         = local.def-location
  rg-name          = local.rg-name
}


resource "azurerm_virtual_network" "vnet" {
  name                = "weight-tracker-vnet"
  location            = local.def-location
  resource_group_name = local.rg-name
  address_space       = ["10.0.0.0/22"]
}

module "subnets" {
  source = "../modules/subnets"

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
  sku                 = "Standard"
}



data "template_file" "custom-data-shell-script" {
  template = file("${path.module}/VM-startup-script-template.sh")

  vars = {
    okta-API-token     = module.azure-vault.okta-API-token
    PGHOST             = ""
    PGPASSWORD         = module.azure-vault.weight-tacker-PSQL-password
    HOST_URL_IP        = local.load-balancer-public-ip-address #Used both for the .env population and to update okta URI's
    COOKIE_ENCRYPT_PWD = module.azure-vault.cookie-encrypt-pwd
    OKTA_CLIENT_SECRET = module.azure-vault.okta-client-secret
  }
}


module "front-load-balancer" {
  source = "../modules/load-balancer"

  rg-name                  = local.rg-name
  def-location             = local.def-location
  public-ip-id             = azurerm_public_ip.load-balancer-public-ip.id
  public-subnet-id         = module.subnets.public-subnet-id
  frontend-port-start      = local.inbound-nat-port-start
  frontend-port-end        = local.inbound-nat-port-start + local.vmss-maximum-instances
  backend-address-pool-ids = [module.front-load-balancer.backend-pool.id]
}

module "application-vmss" {
  source = "../modules/virtual-machine-scale-set"

  location                 = local.def-location
  rg-name                  = local.rg-name
  VM-username              = "ubuntu"
  admin-password           = module.azure-vault.vm-password
  backend-address-pool-ids = [module.front-load-balancer.backend-pool.id]
  nat-rule-ids             = [module.front-load-balancer.inbound-nat-rule-id]
  public-subnet-id         = module.subnets.public-subnet-id
  VM-custom-data           = base64encode(data.template_file.custom-data-shell-script.rendered)
  vmss-maximum-instances   = local.vmss-maximum-instances

  depends_on = [module.front-load-balancer]
}



















