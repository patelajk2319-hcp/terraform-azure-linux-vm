# Key Vault Module - Manages encryption keys for disk encryption
module "key_vault" {
  source = "./modules/key_vault"

  key_vault_name      = "${var.vm_name}-kv-${substr(md5(var.vm_name), 0, 6)}"
  key_name            = "${var.vm_name}-disk-encryption-key"
  region              = var.region
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

# Disk Encryption Set Module - Manages customer-managed key encryption for disks
module "disk_encryption_set" {
  source = "./modules/disk_encryption_set"

  disk_encryption_set_name = "${var.vm_name}-des"
  region                   = var.region
  resource_group_name      = var.resource_group_name
  key_vault_key_id         = module.key_vault.key_vault_key_id
  key_vault_id             = module.key_vault.key_vault_id
  tags                     = var.tags
}

# Network Interface Module - Manages NIC and NSG for the VM
module "network_interface" {
  source = "./modules/network_interface"

  nic_name            = "${var.vm_name}-nic"
  nsg_name            = "${var.vm_name}-nsg"
  region              = var.region
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_id
  tags                = var.tags
}

# Virtual Machine Module - Core VM resource with encrypted OS disk
module "virtual_machine" {
  source = "./modules/virtual_machine"

  vm_name                      = var.vm_name
  region                       = var.region
  resource_group_name          = var.resource_group_name
  network_interface_id         = module.network_interface.network_interface_id
  vm_size                      = var.vm_size
  admin_username               = var.admin_username
  ssh_public_key               = var.ssh_public_key
  os_disk_storage_account_type = local.storage_account_type
  disk_encryption_set_id       = module.disk_encryption_set.disk_encryption_set_id
  tags                         = var.tags

  depends_on = [module.disk_encryption_set]
}

# Data Disks Module - Manages encrypted data disks attached to the VM
module "data_disks" {
  source = "./modules/data_disks"

  vm_name                = var.vm_name
  data_disks_size_gb     = var.data_disks_size_gb
  region                 = var.region
  resource_group_name    = var.resource_group_name
  storage_account_type   = local.storage_account_type
  disk_encryption_set_id = module.disk_encryption_set.disk_encryption_set_id
  virtual_machine_id     = module.virtual_machine.vm_id
  tags                   = var.tags
}
