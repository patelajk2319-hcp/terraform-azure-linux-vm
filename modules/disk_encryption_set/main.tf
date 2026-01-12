# Disk Encryption Set
resource "azurerm_disk_encryption_set" "this" {
  name                = var.disk_encryption_set_name
  location            = var.region
  resource_group_name = var.resource_group_name
  key_vault_key_id    = var.key_vault_key_id

  identity {
    type = "SystemAssigned"
  }

  tags = var.tags
}

# Key Vault Access Policy for Disk Encryption Set
resource "azurerm_key_vault_access_policy" "des" {
  key_vault_id = var.key_vault_id
  tenant_id    = azurerm_disk_encryption_set.this.identity[0].tenant_id
  object_id    = azurerm_disk_encryption_set.this.identity[0].principal_id

  key_permissions = [
    "Get",
    "WrapKey",
    "UnwrapKey",
  ]
}
