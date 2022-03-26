variable "VM-username" {
  type        = string
  description = "Admin username for the virtual machine."
}

variable "location" {
  type        = string
  description = "The location of the resource."
}

variable "rg-name" {
  type        = string
  description = "The name of the resource group the resource will be deployed to."
}

variable "admin-password" {
  type = string
}

variable "VM-custom-data" {
  type        = string
  description = ""
}

variable "public-subnet-id" {
  type = string
}

variable "backend-address-pool-ids" {
  type = list(string)
}


variable "nat-rule-ids" {
  type = list(string)
}

variable "vmss-maximum-instances" {
  type = number
}

