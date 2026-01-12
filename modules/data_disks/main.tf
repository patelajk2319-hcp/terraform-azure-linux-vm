# Managed Data Disks
resource "azurerm_managed_disk" "this" {
  count = length(var.data_disks_size_gb)

  name                   = "${var.vm_name}-datadisk-${count.index}"
  location               = var.region
  resource_group_name    = var.resource_group_name
  storage_account_type   = var.storage_account_type
  create_option          = "Empty"
  disk_size_gb           = var.data_disks_size_gb[count.index]
  disk_encryption_set_id = var.disk_encryption_set_id

  tags = var.tags
}

# Attach data disks to VM
resource "azurerm_virtual_machine_data_disk_attachment" "this" {
  count = length(var.data_disks_size_gb)

  managed_disk_id    = azurerm_managed_disk.this[count.index].id
  virtual_machine_id = var.virtual_machine_id
  lun                = count.index
  caching            = "ReadWrite"
}
