variable "key_vault_name" {
  description = "The name of the Key Vault"
  type        = string
}

variable "key_name" {
  description = "The name of the encryption key"
  type        = string
}

variable "region" {
  description = "The Azure region where the Key Vault will be created"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "tags" {
  description = "A map of tags to assign to the resources"
  type        = map(string)
  default     = {}
}
