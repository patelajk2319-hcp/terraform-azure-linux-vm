output "vm_id" {
  description = "The ID of the virtual machine"
  value       = module.virtual_machine.vm_id
}

output "vm_name" {
  description = "The name of the virtual machine"
  value       = module.virtual_machine.vm_name
}

output "vm_private_ip" {
  description = "The private IP address of the virtual machine"
  value       = module.network_interface.private_ip_address
}

output "disk_encryption_set_id" {
  description = "The ID of the disk encryption set"
  value       = module.disk_encryption_set.disk_encryption_set_id
}

output "key_vault_id" {
  description = "The ID of the Key Vault used for disk encryption"
  value       = module.key_vault.key_vault_id
}

output "key_vault_name" {
  description = "The name of the Key Vault used for disk encryption"
  value       = module.key_vault.key_vault_name
}

output "data_disk_ids" {
  description = "List of IDs of the attached data disks"
  value       = module.data_disks.data_disk_ids
}

output "data_disk_names" {
  description = "List of names of the attached data disks"
  value       = module.data_disks.data_disk_names
}

output "network_interface_id" {
  description = "The ID of the network interface"
  value       = module.network_interface.network_interface_id
}

output "nsg_id" {
  description = "The ID of the network security group"
  value       = module.network_interface.nsg_id
}
