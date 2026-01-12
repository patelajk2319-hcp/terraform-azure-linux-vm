output "data_disk_ids" {
  description = "List of IDs of the data disks"
  value       = azurerm_managed_disk.this[*].id
}

output "data_disk_names" {
  description = "List of names of the data disks"
  value       = azurerm_managed_disk.this[*].name
}

output "attachment_ids" {
  description = "List of IDs of the disk attachments"
  value       = azurerm_virtual_machine_data_disk_attachment.this[*].id
}
