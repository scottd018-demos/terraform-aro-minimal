#
# vnet resource group
#
resource "azurerm_resource_group" "vnet" {
  count = var.resource_group_vnet_create ? 1 : 0

  name     = var.resource_group_vnet
  location = var.location
}

data "azurerm_resource_group" "vnet" {
  count = var.resource_group_vnet_create ? 0 : 1

  name = var.resource_group_vnet
}

#
# vnet
#
locals {
  resource_group_vnet = var.resource_group_vnet_create ? azurerm_resource_group.vnet[0] : data.azurerm_resource_group.vnet[0]
}

resource "azurerm_virtual_network" "aro" {
  name                = var.vnet
  location            = local.resource_group_vnet.location
  resource_group_name = local.resource_group_vnet.name
  address_space       = [var.vnet_cidr_block]
}

#
# subnets
#
resource "azurerm_subnet" "control_plane" {
  name                                           = "${var.vnet}-control-plane"
  resource_group_name                            = local.resource_group_vnet.name
  virtual_network_name                           = azurerm_virtual_network.aro.name
  address_prefixes                               = [var.control_plane_cidr_block]
  service_endpoints                              = ["Microsoft.Storage", "Microsoft.ContainerRegistry"]
  enforce_private_link_service_network_policies  = true
  enforce_private_link_endpoint_network_policies = true

}

resource "azurerm_subnet" "worker" {
  name                 = "${var.vnet}-worker"
  resource_group_name  = local.resource_group_vnet.name
  virtual_network_name = azurerm_virtual_network.aro.name
  address_prefixes     = [var.worker_cidr_block]
  service_endpoints    = ["Microsoft.Storage", "Microsoft.ContainerRegistry"]
}

#
# outputs
#   NOTE: we are outputting these as inputs to our next process.
#
output "vnet_resource_group_name" {
  value = azurerm_virtual_network.aro.resource_group_name
}

output "vnet" {
  value = azurerm_virtual_network.aro.name
}

output "control_plane_subnet" {
  value = azurerm_subnet.control_plane.name
}

output "control_plane_subnet_id" {
  value = azurerm_subnet.control_plane.id
}

output "worker_subnet" {
  value = azurerm_subnet.worker.name
}

output "worker_subnet_id" {
  value = azurerm_subnet.worker.id
}
