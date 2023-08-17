#
# cluster resource group
#
locals {
  create_resource_group_aro = (var.resource_group_aro != null && var.resource_group_aro != "") && var.resource_group_aro_create
}

resource "azurerm_resource_group" "cluster" {
  count = local.create_resource_group_aro ? 1 : 0

  name     = var.resource_group_aro
  location = var.location
}

data "azurerm_resource_group" "cluster" {
  count = local.create_resource_group_aro ? 0 : 1

  name = var.resource_group_aro
}

#
# vnet resource group
#
data "azurerm_resource_group" "vnet" {
  name = var.resource_group_vnet
}

#
# role definitions
#
locals {
  resource_group_aro_id = local.create_resource_group_aro ? azurerm_resource_group.cluster[0].id : data.azurerm_resource_group.cluster[0].id
}

resource "azurerm_role_definition" "cluster_creator" {
  name        = "${var.cluster_name}-cluster-creator"
  scope       = local.resource_group_aro_id
  description = "This role is a set of minimal permissions for the cluster creator over the cluster resource group."

  permissions {
    actions = [
      "Microsoft.RedHatOpenShift/openShiftClusters/read",
      "Microsoft.RedHatOpenShift/openShiftClusters/write",
      "Microsoft.RedHatOpenShift/openShiftClusters/listCredentials/action",
      "Microsoft.RedHatOpenShift/openShiftClusters/listAdminCredentials/action"
    ]
    not_actions = []
  }
}

#
# role assignments: Cluster Creator > Cluster Resource Group
#
resource "azurerm_role_assignment" "cc_cluster_rg" {
  scope              = local.resource_group_aro_id
  role_definition_id = azurerm_role_definition.cluster_creator.role_definition_resource_id
  principal_id       = azuread_service_principal.cluster_creator.object_id
}
