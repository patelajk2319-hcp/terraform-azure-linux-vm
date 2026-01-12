output "network_interface_id" {
  description = "The ID of the network interface"
  value       = azurerm_network_interface.this.id
}

output "network_interface_name" {
  description = "The name of the network interface"
  value       = azurerm_network_interface.this.name
}

output "private_ip_address" {
  description = "The private IP address of the network interface"
  value       = azurerm_network_interface.this.private_ip_address
}

output "nsg_id" {
  description = "The ID of the network security group"
  value       = azurerm_network_security_group.this.id
}

output "nsg_name" {
  description = "The name of the network security group"
  value       = azurerm_network_security_group.this.name
}
