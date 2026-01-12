data "azurerm_client_config" "current" {}

# Key Vault for storing encryption keys
resource "azurerm_key_vault" "this" {
  name                        = var.key_vault_name
  location                    = var.region
  resource_group_name         = var.resource_group_name
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  sku_name                    = "premium"
  enabled_for_disk_encryption = true
  purge_protection_enabled    = true
  soft_delete_retention_days  = 7

  tags = var.tags
}

# Key Vault Access Policy for current user/service principal
resource "azurerm_key_vault_access_policy" "current" {
  key_vault_id = azurerm_key_vault.this.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_client_config.current.object_id

  key_permissions = [
    "Get",
    "Create",
    "Delete",
    "List",
    "Update",
    "Import",
    "Backup",
    "Restore",
    "Recover",
    "GetRotationPolicy",
    "SetRotationPolicy",
  ]
}

# Key Vault Key for disk encryption
resource "azurerm_key_vault_key" "this" {
  name         = var.key_name
  key_vault_id = azurerm_key_vault.this.id
  key_type     = "RSA"
  key_size     = 2048

  key_opts = [
    "decrypt",
    "encrypt",
    "sign",
    "unwrapKey",
    "verify",
    "wrapKey",
  ]

  depends_on = [azurerm_key_vault_access_policy.current]
}
