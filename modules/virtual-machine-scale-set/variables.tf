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

variable "backend-pool-id" {
  type = string
}


variable "inbound-nat-rule-id" {
  type = string
}

variable "vmss-maximum-instances" {
  type = number
}