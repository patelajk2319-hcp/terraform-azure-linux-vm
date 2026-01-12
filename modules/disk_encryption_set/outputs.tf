output "disk_encryption_set_id" {
  description = "The ID of the disk encryption set"
  value       = azurerm_disk_encryption_set.this.id
}

output "disk_encryption_set_name" {
  description = "The name of the disk encryption set"
  value       = azurerm_disk_encryption_set.this.name
}

output "identity_principal_id" {
  description = "The principal ID of the disk encryption set managed identity"
  value       = azurerm_disk_encryption_set.this.identity[0].principal_id
}

output "identity_tenant_id" {
  description = "The tenant ID of the disk encryption set managed identity"
  value       = azurerm_disk_encryption_set.this.identity[0].tenant_id
}
