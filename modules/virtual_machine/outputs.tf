output "vm_id" {
  description = "The ID of the virtual machine"
  value       = azurerm_linux_virtual_machine.this.id
}

output "vm_name" {
  description = "The name of the virtual machine"
  value       = azurerm_linux_virtual_machine.this.name
}

output "vm_identity" {
  description = "The identity block of the virtual machine"
  value       = azurerm_linux_virtual_machine.this.identity
}
