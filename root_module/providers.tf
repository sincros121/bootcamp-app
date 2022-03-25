# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.65"
    }
  }

  required_version = ">= 1.1.7"
}

provider "azurerm" {
  features {}
}

provider "local" {}

provider "template" {}

provider "http" {}