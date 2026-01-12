variable "vm_name" {
  description = "The name of the virtual machine (used for disk naming)"
  type        = string
}

variable "data_disks_size_gb" {
  description = "Array of data disk sizes in GB"
  type        = list(number)
}

variable "region" {
  description = "The Azure region where data disks will be created"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "storage_account_type" {
  description = "The storage account type for data disks"
  type        = string
}

variable "disk_encryption_set_id" {
  description = "The ID of the disk encryption set"
  type        = string
}

variable "virtual_machine_id" {
  description = "The ID of the virtual machine to attach disks to"
  type        = string
}

variable "tags" {
  description = "A map of tags to assign to the resources"
  type        = map(string)
  default     = {}
}
