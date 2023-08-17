variable "location" {
  type        = string
  default     = "East US"
  description = "Default Azure Region to provison to."
}

#
# resource groups
#
variable "resource_group_vnet" {
  type        = string
  description = "Name of the resource group to create (if 'resource_group_vnet_create' is true) or use."

  validation {
    condition     = (var.resource_group_vnet != "" && var.resource_group_vnet != null)
    error_message = "'resource_group_vnet' is a mandatory variable."
  }
}

variable "resource_group_vnet_create" {
  type        = bool
  default     = false
  description = "When supplied with the 'resource_group_vnet' variable, the resource group is automatically created, otherwise it is expected to exist."
}

#
# vnet
#
variable "vnet" {
  type        = string
  description = "Name of the vnet to manage."

  validation {
    condition     = (var.vnet != "" && var.vnet != null)
    error_message = "'vnet' is a mandatory variable."
  }
}

variable "vnet_cidr_block" {
  type        = string
  description = "CIDR block for VNET"
  default     = "10.10.0.0/21"

  validation {
    condition     = (var.vnet_cidr_block != "" && var.vnet_cidr_block != null)
    error_message = "'vnet_cidr_block' is a mandatory variable."
  }
}

#
# subnets
#
variable "control_plane_cidr_block" {
  type        = string
  description = "CIDR block for control plane subnet"
  default     = "10.10.0.0/24"

  validation {
    condition     = (var.control_plane_cidr_block != "" && var.control_plane_cidr_block != null)
    error_message = "'control_plane_cidr_block' is a mandatory variable."
  }
}

variable "worker_cidr_block" {
  type        = string
  description = "CIDR block for worker subnet"
  default     = "10.10.1.0/24"

  validation {
    condition     = (var.worker_cidr_block != "" && var.worker_cidr_block != null)
    error_message = "'worker_cidr_block' is a mandatory variable."
  }
}
