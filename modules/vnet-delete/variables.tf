

variable "vnet-name" {
  type = string
}

variable "location" {
  type        = string
  description = "The location of the resource."
}

variable "rg-name" {
  type        = string
  description = "The name of the resource group the resource will be deployed to."
}

variable "public-subnet-name" {
  type = string
}

variable "private-subnet-name" {
  type = string
}

variable "public-scg" {
  type        = string
  description = "The ID of the public security group."
}

variable "private-scg" {
  type        = string
  description = "The ID of the private security group."
}

