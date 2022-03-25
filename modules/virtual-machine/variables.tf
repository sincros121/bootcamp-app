

variable "VM-amount" {
  type = string
  description = "Amount of instances created, also used to define instance and related resources names."
}

variable "VM-username" {
  type        = string
  description = "Admin username for the virtual machine."
}

variable "VM-name" {
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

variable "application-NIC-id" {
  type        = string
  description = "The ID of the network interface we will be using for the application VM"
}

variable "admin-password" {
  type = string
}

#variable "web-application-image-id" {
#  type        = string
#  default     = "/subscriptions/7f731aec-a948-41c6-9f7c-7bc0908b579c/resourceGroups/Weight_tracker.rg/providers/Microsoft.Compute/galleries/Weight_tracker_images/images/NodejsAppManagedPostgreSQL"
#  description = "The image ID from which we will create our VM."
#}
#
variable "VM-custom-data" {
  type        = string
  description = ""
}



locals {
  env-example = <<ENV
  PORT=8080
  HOST=0.0.0.0

  #postgres
  PGHOST=10.0.1.4
  PGUSERNAME=postgres
  PGDATABASE=postgres
  PGPASSWORD=12345
  PGPORT=5432

  HOST_URL=http://20.124.132.87:8080
  COOKIE_ENCRYPT_PWD=superAwesomePasswordStringThatIsAtLeast32CharactersLong!
  NODE_ENV=development

  # Okta configuration
  OKTA_ORG_URL=https://dev-77800982.okta.com
  OKTA_CLIENT_ID=0oa4693606L8GlUED5d7
  OKTA_CLIENT_SECRET=syY6wpJPxvuYTcmKfLWJ7cZaIcheSWJ-koJs_YS1
  ENV




  script = <<SCRIPT
  #!/bin/sh
  sudo apt update
  curl -sL https://deb.nodesource.com/setup_14.x | sudo bash -
  sudo apt -y install nodejs
  git clone https://github.com/sincros121/bootcamp-app.git
  cd bootcamp-app
  npm install
  sudo npm install pm2@latest -g
  pm2 startup
  sudo env PATH=$PATH:/usr/bin /usr/lib/node_modules/pm2/bin/pm2 startup systemd -u ubuntu --hp /home/ubuntu
  touch .env $
  SCRIPT

  encoded-script = base64encode("${local.script}")
}
