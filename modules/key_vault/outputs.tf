output "key_vault_id" {
  description = "The ID of the Key Vault"
  value       = azurerm_key_vault.this.id
}

output "key_vault_name" {
  description = "The name of the Key Vault"
  value       = azurerm_key_vault.this.name
}

output "key_vault_key_id" {
  description = "The ID of the Key Vault key"
  value       = azurerm_key_vault_key.this.id
}

output "tenant_id" {
  description = "The tenant ID for access policies"
  value       = data.azurerm_client_config.current.tenant_id
}
