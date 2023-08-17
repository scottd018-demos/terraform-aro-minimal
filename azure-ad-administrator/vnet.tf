data "azurerm_virtual_network" "vnet" {
  name                = var.vnet
  resource_group_name = var.resource_group_vnet
}

#
# role definitions
#
resource "azurerm_role_definition" "vnet" {
  name        = "${var.cluster_name}-vnet"
  scope       = data.azurerm_virtual_network.vnet.id
  description = "This role is a set of minimal permissions allowed to interact with vnet ${var.vnet} for cluster ${var.cluster_name}"

  permissions {
    actions = [
      "Microsoft.Network/virtualNetworks/join/action",
      "Microsoft.Network/virtualNetworks/read",
      "Microsoft.Network/virtualNetworks/write",
      "Microsoft.Network/virtualNetworks/subnets/join/action",
      "Microsoft.Network/virtualNetworks/subnets/read",
      "Microsoft.Network/virtualNetworks/subnets/write",
    ]
    not_actions = []
  }
}

resource "azurerm_role_definition" "nat_gateways" {
  count = var.vnet_has_nat_gateways ? 1 : 0

  name        = "${var.cluster_name}-vnet-nat-gateways"
  scope       = data.azurerm_virtual_network.vnet.id
  description = "This role is a set of minimal permissions allowed to interact with vnet NAT gateways ${var.vnet} for cluster ${var.cluster_name}"

  permissions {
    actions = [
      "Microsoft.Network/natGateways/join/action",
      "Microsoft.Network/natGateways/read",
      "Microsoft.Network/natGateways/write"
    ]
    not_actions = []
  }
}

resource "azurerm_role_definition" "route_tables" {
  count = var.vnet_has_route_tables ? 1 : 0

  name        = "${var.cluster_name}-vnet-route-tables"
  scope       = data.azurerm_virtual_network.vnet.id
  description = "This role is a set of minimal permissions allowed to interact with vnet route tables ${var.vnet} for cluster ${var.cluster_name}"

  permissions {
    actions = [
      "Microsoft.Network/routeTables/join/action",
      "Microsoft.Network/routeTables/read",
      "Microsoft.Network/routeTables/write"
    ]
    not_actions = []
  }
}

#
# role assignments: ARO Service Principal > VNET
#
resource "azurerm_role_assignment" "aro_sp_vnet" {
  scope                            = data.azurerm_virtual_network.vnet.id
  role_definition_id               = azurerm_role_definition.vnet.role_definition_resource_id
  principal_id                     = data.azuread_service_principal.aro_resource_provider.object_id
  skip_service_principal_aad_check = true
}

resource "azurerm_role_assignment" "aro_sp_nat_gateways" {
  count = var.vnet_has_nat_gateways ? 1 : 0

  scope                            = data.azurerm_virtual_network.vnet.id
  role_definition_id               = azurerm_role_definition.nat_gateways[0].role_definition_resource_id
  principal_id                     = data.azuread_service_principal.aro_resource_provider.object_id
  skip_service_principal_aad_check = true
}

resource "azurerm_role_assignment" "aro_sp_route_tables" {
  count = var.vnet_has_route_tables ? 1 : 0

  scope                            = data.azurerm_virtual_network.vnet.id
  role_definition_id               = azurerm_role_definition.route_tables[0].role_definition_resource_id
  principal_id                     = data.azuread_service_principal.aro_resource_provider.object_id
  skip_service_principal_aad_check = true
}

#
# role assignments: Cluster Service Principal > VNET
#
resource "azurerm_role_assignment" "csp_sp_vnet" {
  scope              = data.azurerm_virtual_network.vnet.id
  role_definition_id = azurerm_role_definition.vnet.role_definition_resource_id
  principal_id       = azuread_service_principal.cluster.object_id
}

resource "azurerm_role_assignment" "csp_sp_nat_gateways" {
  count = var.vnet_has_nat_gateways ? 1 : 0

  scope              = data.azurerm_virtual_network.vnet.id
  role_definition_id = azurerm_role_definition.nat_gateways[0].role_definition_resource_id
  principal_id       = azuread_service_principal.cluster.object_id
}

resource "azurerm_role_assignment" "csp_sp_route_tables" {
  count = var.vnet_has_route_tables ? 1 : 0

  scope              = data.azurerm_virtual_network.vnet.id
  role_definition_id = azurerm_role_definition.route_tables[0].role_definition_resource_id
  principal_id       = azuread_service_principal.cluster.object_id
}
