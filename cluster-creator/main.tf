resource "azureopenshift_redhatopenshift_cluster" "cluster" {
  name                   = var.cluster_name
  location               = var.location
  resource_group_name    = var.resource_group_aro
  cluster_resource_group = "${var.cluster_name}-cluster-rg"

  master_profile {
    subnet_id = var.control_plane_subnet_id
  }

  worker_profile {
    subnet_id = var.worker_subnet_id
  }

  service_principal {
    client_id     = var.service_principal_cluster_client_id
    client_secret = var.service_principal_cluster_client_secret
  }

  api_server_profile {
    visibility = var.visibility_api
  }

  ingress_profile {
    visibility = var.visibility_ingress
  }

  cluster_profile {
    pull_secret = file(var.pull_secret_path)
    version     = var.cluster_version
  }
}
