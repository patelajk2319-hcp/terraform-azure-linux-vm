# Virtual Machine
# Note: source_image_reference will be replaced with a custom hardened image from image repository in the future
resource "azurerm_linux_virtual_machine" "this" {
  name                  = var.vm_name
  location              = var.region
  resource_group_name   = var.resource_group_name
  network_interface_ids = [var.network_interface_id]
  size                  = var.vm_size

  admin_username                  = var.admin_username
  disable_password_authentication = true

  admin_ssh_key {
    username   = var.admin_username
    public_key = var.ssh_public_key
  }

  os_disk {
    name                   = "${var.vm_name}-osdisk"
    caching                = "ReadWrite"
    storage_account_type   = var.os_disk_storage_account_type
    disk_encryption_set_id = var.disk_encryption_set_id
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  tags = var.tags
}
