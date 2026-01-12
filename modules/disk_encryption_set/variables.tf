variable "disk_encryption_set_name" {
  description = "The name of the disk encryption set"
  type        = string
}

variable "region" {
  description = "The Azure region where the disk encryption set will be created"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "key_vault_key_id" {
  description = "The ID of the Key Vault key to use for encryption"
  type        = string
}

variable "key_vault_id" {
  description = "The ID of the Key Vault"
  type        = string
}

variable "tags" {
  description = "A map of tags to assign to the resources"
  type        = map(string)
  default     = {}
}
