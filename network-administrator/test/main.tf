variable "location" {}
variable "vnet" {}
variable "resource_group_vnet" {}

module "test" {
  source = "../"

  location = var.location

  vnet                       = var.vnet
  resource_group_vnet        = var.resource_group_vnet
  resource_group_vnet_create = true
}

output "network_administrator_outputs" {
  value = module.test
}
