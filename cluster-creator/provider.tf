terraform {
  required_providers {
    azureopenshift = {
      source  = "rh-mobb/azureopenshift"
      version = "~>0.0.17"
    }
  }
}

provider "azureopenshift" {
  tenant_id       = var.tenant_id
  subscription_id = var.subscription_id
  client_id       = var.service_principal_cluster_creator_client_id
  client_secret   = var.service_principal_cluster_creator_client_secret
}
