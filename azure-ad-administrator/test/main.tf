variable "location" {}
variable "cluster_name" {}
variable "vnet" {}
variable "resource_group_vnet" {}
variable "resource_group_aro" {}

module "test" {
  source = "../"

  location     = var.location
  cluster_name = var.cluster_name

  vnet                  = var.vnet
  vnet_has_nat_gateways = false
  vnet_has_route_tables = false

  resource_group_vnet       = var.resource_group_vnet
  resource_group_aro_create = true
  resource_group_aro        = var.resource_group_aro
}

output "test" {
  value     = module.test
  sensitive = true
}
