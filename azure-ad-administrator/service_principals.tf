data "azuread_client_config" "current" {}

#
# cluster service principal
#
resource "azuread_application" "cluster" {
  display_name = "${var.cluster_name}-cluster"
  owners       = [data.azuread_client_config.current.object_id]
}

resource "azuread_application_password" "cluster" {
  display_name          = "${var.cluster_name}-cluster"
  application_object_id = azuread_application.cluster.object_id
}

resource "azuread_service_principal" "cluster" {
  application_id = azuread_application.cluster.application_id
  owners         = [data.azuread_client_config.current.object_id]
}
#
# cluster creator service principal
#
resource "azuread_application" "cluster_creator" {
  display_name = "${var.cluster_name}-cluster-creator"
  owners       = [data.azuread_client_config.current.object_id]
}

resource "azuread_application_password" "cluster_creator" {
  display_name          = "${var.cluster_name}-cluster-creator"
  application_object_id = azuread_application.cluster_creator.object_id
}

resource "azuread_service_principal" "cluster_creator" {
  application_id = azuread_application.cluster_creator.application_id
  owners         = [data.azuread_client_config.current.object_id]
}

#
# aro resource provider service principal
#   NOTE: this is created by the 'az provider register' commands and will be pre-existing.
#
data "azuread_service_principal" "aro_resource_provider" {
  display_name = "Azure Red Hat OpenShift RP"
}
