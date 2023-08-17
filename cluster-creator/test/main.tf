# credential inputs
variable "service_principal_cluster_client_id" {}
variable "service_principal_cluster_client_secret" {}
variable "service_principal_cluster_creator_client_id" {}
variable "service_principal_cluster_creator_client_secret" {}
variable "tenant_id" {}
variable "subscription_id" {}

# cluster inputs
variable "location" {
  default = "East US"
}

variable "cluster_name" {
  default = "dscott-test"
}

variable "resource_group_aro" {
  default = "dscott-tf-test-rg"
}

# networking inputs
variable "resource_group_vnet" {}
variable "control_plane_subnet_id" {}
variable "worker_subnet_id" {}

module "test" {
  source = "../"

  # credentials
  tenant_id                                       = var.tenant_id
  subscription_id                                 = var.subscription_id
  service_principal_cluster_client_id             = var.service_principal_cluster_client_id
  service_principal_cluster_client_secret         = var.service_principal_cluster_client_secret
  service_principal_cluster_creator_client_id     = var.service_principal_cluster_creator_client_id
  service_principal_cluster_creator_client_secret = var.service_principal_cluster_creator_client_secret

  # cluster
  location           = var.location
  cluster_name       = var.cluster_name
  resource_group_aro = var.resource_group_aro
  pull_secret_path   = "~/.azure/aro-pull-secret.txt"

  # networking
  resource_group_vnet     = var.resource_group_vnet
  control_plane_subnet_id = var.control_plane_subnet_id
  worker_subnet_id        = var.worker_subnet_id
}
