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

#
# providers
#
variable "manage_openshift_provider" {
  type        = bool
  default     = false
  description = "Request Terraform to manage the 'az provider register' process for the 'Microsoft.RedHatOpenShift' provider."
}

variable "manage_compute_provider" {
  type        = bool
  default     = false
  description = "Request Terraform to manage the 'az provider register' process for the 'Microsoft.Compute' provider."
}

variable "manage_storage_provider" {
  type        = bool
  default     = false
  description = "Request Terraform to manage the 'az provider register' process for the 'Microsoft.Storage' provider."
}

variable "manage_authorization_provider" {
  type        = bool
  default     = false
  description = "Request Terraform to manage the 'az provider register' process for the 'Microsoft.Authorization' provider."
}

#
# resource groups
#
variable "resource_group_aro_create" {
  type        = bool
  default     = false
  description = "When supplied with the 'resource_group_aro' variable, the resource group is automatically created, otherwise it is expected to exist."
}

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
# vnet
#
variable "vnet" {
  type        = string
  description = "Name of the pre-existing vnet which exists within the 'resource_group_vnet' variable."

  validation {
    condition     = (var.vnet != "" && var.vnet != null)
    error_message = "'vnet' is a mandatory variable."
  }
}

variable "vnet_has_nat_gateways" {
  type        = bool
  description = "Set to 'true' if the 'vnet' variable has attached NAT Gateways to ensure appropriate permissions are assigned."
  default     = false
}

variable "vnet_has_route_tables" {
  type        = bool
  description = "Set to 'true' if the 'vnet' variable has attached route tables to ensure appropriate permissions are assigned."
  default     = false
}
