variable "vm_name" {
  description = "The name of the virtual machine"
  type        = string
}

variable "region" {
  description = "The Azure region where the VM will be created"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "network_interface_id" {
  description = "The ID of the network interface to attach to the VM"
  type        = string
}

variable "vm_size" {
  description = "The size of the virtual machine"
  type        = string
}

variable "admin_username" {
  description = "The admin username for the virtual machine"
  type        = string
}

variable "ssh_public_key" {
  description = "The SSH public key for authentication"
  type        = string
  sensitive   = true
}

variable "os_disk_storage_account_type" {
  description = "The storage account type for the OS disk"
  type        = string
}

variable "disk_encryption_set_id" {
  description = "The ID of the disk encryption set"
  type        = string
}

variable "tags" {
  description = "A map of tags to assign to the resources"
  type        = map(string)
  default     = {}
}
