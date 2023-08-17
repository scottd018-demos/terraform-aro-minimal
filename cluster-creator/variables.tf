variable "location" {
  type        = string
  default     = "East US"
  description = "Default Azure Region to provison to."
}

variable "cluster_name" {
  type        = string
  description = "Name of the cluster to setup the account for.  This will derive the name of the Cluster Service Principal and the Cluster Creator Service Principal."

  validation {
    condition     = (var.cluster_name != "" && var.cluster_name != null)
    error_message = "'cluster_name' is a mandatory variable."
  }
}

variable "cluster_version" {
  type        = string
  description = "ARO version to deploy."
  default     = "4.11.26"
}

variable "pull_secret_path" {
  type        = string
  default     = false
  description = "Pull Secret for the ARO cluster"
}

#
# resource groups
#
variable "resource_group_aro" {
  type        = string
  description = "Name of the resource group to create or assign permissions which contains the ARO object (may be the same as resource_group_vnet)."

  validation {
    condition     = (var.resource_group_aro != "" && var.resource_group_aro != null)
    error_message = "'resource_group_aro' is a mandatory variable."
  }
}

variable "resource_group_vnet" {
  type        = string
  description = "Name of the resource group to create or assign permissions which contains the VNET object (may be the same as resource_group_aro).  Must be pre-existing and must contain the value of the 'vnet' variable."

  validation {
    condition     = (var.resource_group_vnet != "" && var.resource_group_vnet != null)
    error_message = "'resource_group_vnet' is a mandatory variable."
  }
}

#
# subnet info
#
variable "control_plane_subnet_id" {
  type        = string
  description = "ID of the pre-existing subnet to place the control plane nodes in."

  validation {
    condition     = (var.control_plane_subnet_id != "" && var.control_plane_subnet_id != null)
    error_message = "'control_plane_subnet_id' is a mandatory variable."
  }
}

variable "worker_subnet_id" {
  type        = string
  description = "ID of the pre-existing subnet to place the worker nodes in."

  validation {
    condition     = (var.worker_subnet_id != "" && var.worker_subnet_id != null)
    error_message = "'worker_subnet_id' is a mandatory variable."
  }
}

#
# visibility info
#
variable "visibility_api" {
  type        = string
  description = "API Visibility - Public or Private"
  default     = "Public"

  validation {
    condition     = contains(["Public", "Private"], var.visibility_api)
    error_message = "'visibility_api' must either be set to 'Public' or 'Private'."
  }
}

variable "visibility_ingress" {
  type        = string
  description = "Ingress Visibility - Public or Private"
  default     = "Public"

  validation {
    condition     = contains(["Public", "Private"], var.visibility_ingress)
    error_message = "'visibility_ingress' must either be set to 'Public' or 'Private'."
  }
}

#
# subscription info
#
variable "subscription_id" {
  type        = string
  description = "Subscription ID to use - required to authenticate as the Cluster Creator Service Principal"
}

variable "tenant_id" {
  type        = string
  description = "Tenant ID to use - required to authenticate as the Cluster Creator Service Principal"
}

#
# cluster credentials
#
variable "service_principal_cluster_client_id" {
  type        = string
  sensitive   = true
  description = "Client ID of the Cluster Service Principal (id for the 'service_principal_cluster_client_secret')"

  validation {
    condition     = (var.service_principal_cluster_client_id != "" && var.service_principal_cluster_client_id != null)
    error_message = "'service_principal_cluster_client_id' is a mandatory variable."
  }
}

variable "service_principal_cluster_client_secret" {
  type        = string
  sensitive   = true
  description = "Client Secret of the Cluster Service Principal (secret for the 'service_principal_cluster_client_id')"

  validation {
    condition     = (var.service_principal_cluster_client_secret != "" && var.service_principal_cluster_client_secret != null)
    error_message = "'service_principal_cluster_client_secret' is a mandatory variable."
  }
}

#
# cluster creator credentials
#
variable "service_principal_cluster_creator_client_id" {
  type        = string
  sensitive   = true
  description = "Client ID of the Cluster Creator Service Principal (id for the 'service_principal_cluster_creator_client_secret')"

  validation {
    condition     = (var.service_principal_cluster_creator_client_id != "" && var.service_principal_cluster_creator_client_id != null)
    error_message = "'service_principal_cluster_creator_client_id' is a mandatory variable."
  }
}

variable "service_principal_cluster_creator_client_secret" {
  type        = string
  sensitive   = true
  description = "Client Secret of the Cluster Creator Service Principal (secret for the 'service_principal_cluster_creator_client_id')"

  validation {
    condition     = (var.service_principal_cluster_creator_client_secret != "" && var.service_principal_cluster_creator_client_secret != null)
    error_message = "'service_principal_cluster_creator_client_secret' is a mandatory variable."
  }
}
