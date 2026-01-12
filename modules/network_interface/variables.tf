variable "nic_name" {
  description = "The name of the network interface"
  type        = string
}

variable "nsg_name" {
  description = "The name of the network security group"
  type        = string
}

variable "region" {
  description = "The Azure region where resources will be created"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "subnet_id" {
  description = "The ID of the subnet to attach the network interface to"
  type        = string
}

variable "tags" {
  description = "A map of tags to assign to the resources"
  type        = map(string)
  default     = {}
}
