# Azure Linux VM Terraform Module

Production-ready Terraform module for deploying Azure Linux VMs with customer-managed disk encryption.

## Features

- Customer-managed disk encryption (Key Vault + Disk Encryption Set)
- Network Security Group
- Configurable data disks
- Environment-based storage tiers (dev/test/uat = Standard_LRS, prod/pre-prod = Premium_ZRS)
- SSH key authentication only

## Provider Requirements

This is a Terraform module and does not include provider configuration. The consuming root module must configure the Azure provider:

```hcl
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}
```

## Usage

```hcl
module "linux_vm" {
  source = "github.com/patelajk2319-hcp/terraform-azure-linux-vm"

  vm_name             = "my-app-vm"
  region              = "eastus"
  environment         = "prod"
  resource_group_name = "my-rg"
  subnet_id           = "/subscriptions/.../subnets/my-subnet"
  ssh_public_key      = file("~/.ssh/id_rsa.pub")

  data_disks_size_gb = [32, 64]
}
```

## Testing

Run unit tests to validate module configuration:

```bash
# Run all tests
task test

# Or directly
terraform test
```

## Testing Locally with Real Resources

```bash
# 1. Setup
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with your values

# 2. Login and Deploy
task login  # or: az login
terraform init
terraform apply

# 3. Verify SSH is configured (VM has private IP only)
az vm run-command invoke \
  --resource-group <RG> --name <VM> \
  --command-id RunShellScript \
  --scripts "whoami && hostname"
```


## Inputs

| Name | Required | Default | Description |
|------|----------|---------|-------------|
| vm_name | Y | - | VM name (1-64 chars, lowercase/numbers/hyphens) |
| region | Y | - | Azure region |
| environment | Y | - | Environment: dev/test/uat/pre-prod/prod |
| resource_group_name | Y | - | Resource group name |
| subnet_id | Y | - | Subnet ID (full Azure resource ID) |
| ssh_public_key | Y | - | SSH public key content |
| vm_size | N | `Standard_B2s` | Azure VM size |
| data_disks_size_gb | N | `[]` | List of disk sizes in GB |
| admin_username | N | `azureuser` | Admin username |
| tags | N | `{}` | Resource tags |

## Outputs

`vm_id`, `vm_name`, `vm_private_ip`, `key_vault_id`, `key_vault_name`, `disk_encryption_set_id`, `data_disk_ids`, `network_interface_id`, `nsg_id`

## Notes

- Requires existing VNet/Subnet
- Key Vault has 7-day soft delete (use `az keyvault purge --name <NAME>` to permanently delete)
- VM uses Ubuntu 22.04 LTS
- All disks encrypted with customer-managed keys

---

**Owner**: HashiCorp Services
