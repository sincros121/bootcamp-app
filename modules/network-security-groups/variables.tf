

variable "public-nsg-name" {
  type = string
}

variable "private-nsg-name" {
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

#variable "user-IP-for-SSH" {
#  type        = string
#  description = "This is the users IP address that will be allowed SSH access via the 'Public' security group"
#}