# Basic validation test - validates module configuration without actually deploying
run "validate_vm_name" {
  command = plan

  variables {
    vm_name             = "test-vm-01"
    region              = "eastus"
    environment         = "dev"
    resource_group_name = "test-rg"
    subnet_id           = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/test-rg/providers/Microsoft.Network/virtualNetworks/test-vnet/subnets/test-subnet"
    ssh_public_key      = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDTest test@example.com"
  }

  assert {
    condition     = length(var.vm_name) > 0 && length(var.vm_name) <= 64
    error_message = "VM name must be between 1 and 64 characters"
  }
}

run "validate_environment" {
  command = plan

  variables {
    vm_name             = "test-vm-02"
    region              = "eastus"
    environment         = "prod"
    resource_group_name = "test-rg"
    subnet_id           = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/test-rg/providers/Microsoft.Network/virtualNetworks/test-vnet/subnets/test-subnet"
    ssh_public_key      = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDTest test@example.com"
  }

  assert {
    condition     = contains(["dev", "test", "uat", "pre-prod", "prod"], var.environment)
    error_message = "Environment must be valid"
  }
}

run "validate_disk_sizes" {
  command = plan

  variables {
    vm_name             = "test-vm-03"
    region              = "eastus"
    environment         = "dev"
    resource_group_name = "test-rg"
    subnet_id           = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/test-rg/providers/Microsoft.Network/virtualNetworks/test-vnet/subnets/test-subnet"
    ssh_public_key      = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDTest test@example.com"
    data_disks_size_gb  = [4, 8, 16]
  }

  assert {
    condition     = alltrue([for size in var.data_disks_size_gb : size >= 1 && size <= 32767])
    error_message = "All disk sizes must be between 1 and 32767 GB"
  }
}

run "validate_outputs" {
  command = plan

  variables {
    vm_name             = "test-vm-04"
    region              = "eastus"
    environment         = "dev"
    resource_group_name = "test-rg"
    subnet_id           = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/test-rg/providers/Microsoft.Network/virtualNetworks/test-vnet/subnets/test-subnet"
    ssh_public_key      = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDTest test@example.com"
    data_disks_size_gb  = [4, 4]
  }

  assert {
    condition     = output.vm_name == var.vm_name
    error_message = "VM name output should match input variable"
  }

  assert {
    condition     = output.key_vault_name != ""
    error_message = "Key vault name should be generated"
  }
}
