variable "vm_name" {
  description = "The name of the virtual machine"
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]{1,64}$", var.vm_name))
    error_message = "VM name must be 1-64 characters long and contain only lowercase letters, numbers, and hyphens."
  }
}

variable "region" {
  description = "The Azure region where resources will be created (uksouth or ukwest only)"
  type        = string
}

variable "data_disks_size_gb" {
  description = "Array of data disk sizes in GB"
  type        = list(number)
  default     = []

  validation {
    condition     = alltrue([for size in var.data_disks_size_gb : size >= 1 && size <= 32767])
    error_message = "Disk sizes must be between 1 and 32767 GB."
  }
}

variable "resource_group_name" {
  description = "The name of the resource group where resources will be created"
  type        = string
}

variable "subnet_id" {
  description = "The ID of the subnet where the VM network interface will be attached"
  type        = string

  validation {
    condition     = can(regex("^/subscriptions/[^/]+/resourceGroups/[^/]+/providers/Microsoft.Network/virtualNetworks/[^/]+/subnets/[^/]+$", var.subnet_id))
    error_message = "Subnet ID must be a valid Azure subnet resource ID."
  }
}

variable "environment" {
  description = "Environment name (dev, test, uat, pre-prod, prod). Determines storage account type: dev/test/uat use Standard_LRS, pre-prod/prod use Premium_ZRS"
  type        = string

  validation {
    condition     = contains(["dev", "test", "uat", "pre-prod", "prod"], var.environment)
    error_message = "Environment must be one of: dev, test, uat, pre-prod, prod."
  }
}

variable "vm_size" {
  description = "The size of the virtual machine"
  type        = string
  default     = "Standard_B2s"
}

variable "admin_username" {
  description = "The admin username for the virtual machine"
  type        = string
  default     = "azureuser"

  validation {
    condition     = can(regex("^[a-z_][a-z0-9_-]{0,31}$", var.admin_username))
    error_message = "Admin username must start with a letter or underscore, contain only lowercase letters, numbers, hyphens, and underscores, and be 1-32 characters long."
  }
}

variable "ssh_public_key" {
  description = "The SSH public key for authentication"
  type        = string
  sensitive   = true
}

variable "tags" {
  description = "A map of tags to assign to the resources"
  type        = map(string)
  default     = {}
}
