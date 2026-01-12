# Azure Linux VM Terraform Module

A production-ready, reusable Terraform module for deploying Azure Linux Virtual Machines with enterprise-grade security features including customer-managed disk encryption, network security groups, and modular architecture.

This Terraform module deploys an Azure Linux Virtual Machine with disk encryption enabled using Azure Disk Encryption Sets. All disks (OS and data disks) are encrypted using customer-managed keys stored in Azure Key Vault.

## Module Architecture

The module is organized into separate submodules for clear separation of concerns:

```
vm/
├── main.tf                    # Root module orchestrating all components
├── variables.tf               # Root module input variables
├── outputs.tf                 # Root module outputs
├── README.md                  # This file
└── modules/
    ├── key_vault/            # Manages Key Vault and encryption keys
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    ├── disk_encryption_set/  # Manages disk encryption set
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    ├── network_interface/    # Manages NIC and NSG
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    ├── virtual_machine/      # Core VM resource with encrypted OS disk
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    └── data_disks/           # Manages encrypted data disks
        ├── main.tf
        ├── variables.tf
        └── outputs.tf
```

## Features

- Azure Linux Virtual Machine with configurable size
- Disk Encryption Set with customer-managed keys
- Azure Key Vault for encryption key management
- Configurable data disks passed as an array
- Network Interface with Security Group
- Modular structure with clear component separation
- Follows Terraform best practices with proper validation and defaults

## Prerequisites

Before using this module, ensure you have:

1. **Azure CLI** installed and configured
2. **Terraform** >= 1.3 installed
3. **Azure Subscription** with appropriate permissions
4. **Existing Virtual Network and Subnet** where the VM will be deployed
5. **SSH Key Pair** for VM authentication

### Generate SSH Key (if needed)

```bash
ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -C "your-email@example.com"
```

## Quick Start

### Using the Module in Your Terraform Configuration

```hcl
module "linux_vm" {
  source = "github.com/patelajk2319-hcp/terraform-azure-linux-vm"

  vm_name             = "my-app-vm"
  region              = "eastus"
  environment         = "dev"
  resource_group_name = "my-resource-group"
  subnet_id           = "/subscriptions/SUBSCRIPTION_ID/resourceGroups/RG_NAME/providers/Microsoft.Network/virtualNetworks/VNET_NAME/subnets/SUBNET_NAME"

  vm_size            = "Standard_D2s_v3"
  data_disks_size_gb = [32, 64]

  admin_username = "azureuser"
  ssh_public_key = file("~/.ssh/id_rsa.pub")

  tags = {
    Environment = "Development"
    ManagedBy   = "Terraform"
  }
}
```

## Testing the Module Locally

For testing the module locally, follow these steps:

### Step 1: Login to Azure

```bash
# Navigate to the module directory
cd terraform-azure-linux-vm

# Login to Azure (if using Task runner)
task login

# Or use Azure CLI directly
az login
az account set --subscription <SUBSCRIPTION_ID>
```

### Step 2: Configure Variables

Create a `terraform.tfvars` file based on the example:

```bash
cp terraform.tfvars.example terraform.tfvars
```

Edit `terraform.tfvars` with your values:

```hcl
# Azure Configuration
subscription_id = "your-subscription-id"
tenant_id       = "your-tenant-id"

# VM Configuration
vm_name             = "test-vm-01"
region              = "eastus"
environment         = "dev"
resource_group_name = "your-resource-group"

# Network Configuration (ensure VNet and subnet exist)
subnet_id = "/subscriptions/SUB_ID/resourceGroups/RG_NAME/providers/Microsoft.Network/virtualNetworks/VNET_NAME/subnets/SUBNET_NAME"

# VM Size and Disks
vm_size            = "Standard_D2s_v3"
data_disks_size_gb = [4, 4]

# SSH Configuration
admin_username      = "azureuser"
ssh_public_key_path = "~/.ssh/id_rsa.pub"

# Tags
tags = {
  Environment = "test"
  Purpose     = "module-validation"
  ManagedBy   = "terraform"
}
```

### Step 3: Initialize and Deploy

```bash
# Initialize Terraform
terraform init

# Validate configuration
terraform validate

# Review the execution plan
terraform plan

# Apply the configuration
terraform apply
```

### Step 4: Verify Deployment

```bash
# Get outputs
terraform output

# Verify VM in Azure
az vm show --name <VM_NAME> --resource-group <RESOURCE_GROUP> --query "{Name:name, State:provisioningState, Size:hardwareProfile.vmSize}" -o table

# Verify disks and encryption
az disk list --resource-group <RESOURCE_GROUP> --query "[?contains(name, '<VM_NAME>')].{Name:name, Size:diskSizeGb, Encryption:encryption.type}" -o table
```

## Testing SSH Access

Since the VM is deployed with a private IP address by default, you have several options to test SSH connectivity:

### Option 1: Using Azure Bastion (Recommended for Production)

```bash
# Connect through Azure Bastion (requires Bastion deployed in your VNet)
az network bastion ssh \
  --name <BASTION_NAME> \
  --resource-group <BASTION_RG> \
  --target-resource-id <VM_RESOURCE_ID> \
  --auth-type ssh-key \
  --username azureuser \
  --ssh-key ~/.ssh/id_rsa
```

### Option 2: Using Azure VM Run Command (Quick Test)

```bash
# Verify SSH service is running
az vm run-command invoke \
  --resource-group <RESOURCE_GROUP> \
  --name <VM_NAME> \
  --command-id RunShellScript \
  --scripts "whoami && hostname && systemctl status sshd"

# Test SSH configuration
az vm run-command invoke \
  --resource-group <RESOURCE_GROUP> \
  --name <VM_NAME> \
  --command-id RunShellScript \
  --scripts "cat /home/azureuser/.ssh/authorized_keys"
```

### Option 3: From Within the VNet (Jump Box)

If you have a jump box or another VM in the same VNet:

```bash
# SSH from jump box using private IP
ssh -i ~/.ssh/id_rsa azureuser@<PRIVATE_IP>

# Example
ssh -i ~/.ssh/id_rsa azureuser@10.0.1.4
```

### Option 4: Temporary Public IP (Testing Only)

For temporary testing, you can add a public IP through Azure Portal or CLI, but this should **not** be used in production.

## Usage Examples

### Advanced Example

```hcl
module "azure_vm" {
  source = "./path/to/module"

  vm_name             = "app-server-01"
  region              = "westeurope"
  resource_group_name = "production-rg"
  subnet_id           = azurerm_subnet.main.id
  environment         = "prod"
  vm_size             = "Standard_D4s_v3"
  data_disks_size_gb  = [100, 200, 500]
  admin_username      = "adminuser"
  ssh_public_key      = file("~/.ssh/id_rsa.pub")

  tags = {
    Environment = "Production"
    Application = "WebServer"
    CostCenter  = "IT-1234"
  }
}
```

### Development Environment Example

```hcl
module "azure_vm_dev" {
  source = "./path/to/module"

  vm_name             = "dev-vm"
  region              = "northeurope"
  resource_group_name = "dev-rg"
  subnet_id           = azurerm_subnet.dev.id
  environment         = "dev"
  data_disks_size_gb  = [32, 64]
  ssh_public_key      = file("~/.ssh/id_rsa.pub")

  tags = {
    Environment = "Development"
  }
}
```

## Required Inputs

| Name | Description | Type |
|------|-------------|------|
| vm_name | The name of the virtual machine | `string` |
| region | The Azure region where resources will be created | `string` |
| resource_group_name | The name of the resource group where resources will be created | `string` |
| subnet_id | The ID of the subnet where the VM network interface will be attached | `string` |
| environment | Environment name (determines storage type) | `string` |
| ssh_public_key | The SSH public key for authentication | `string` |

**Environment Values:**
- `dev`, `test`, `uat` → Uses **Standard_LRS** (cost-effective for non-production)
- `pre-prod`, `prod` → Uses **Premium_ZRS** (high-performance with zone redundancy)

## Optional Inputs

| Name | Description | Type | Default |
|------|-------------|------|---------|
| data_disks_size_gb | Array of data disk sizes in GB | `list(number)` | `[]` |
| vm_size | The size of the virtual machine | `string` | `"Standard_B2s"` |
| admin_username | The admin username for the virtual machine | `string` | `"azureuser"` |
| tags | A map of tags to assign to the resources | `map(string)` | `{}` |

## Outputs

| Name | Description |
|------|-------------|
| vm_id | The ID of the virtual machine |
| vm_name | The name of the virtual machine |
| vm_private_ip | The private IP address of the virtual machine |
| disk_encryption_set_id | The ID of the disk encryption set |
| key_vault_id | The ID of the Key Vault used for disk encryption |
| key_vault_name | The name of the Key Vault used for disk encryption |
| data_disk_ids | List of IDs of the attached data disks |
| data_disk_names | List of names of the attached data disks |
| network_interface_id | The ID of the network interface |
| nsg_id | The ID of the network security group |

## Complete Example with VNet and Resource Group

This module requires an existing resource group, VNet, and subnet. Here's a complete example:

```hcl
# Create Resource Group
resource "azurerm_resource_group" "example" {
  name     = "my-resource-group"
  location = "eastus"
}

# Create Virtual Network
resource "azurerm_virtual_network" "example" {
  name                = "my-vnet"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  address_space       = ["10.0.0.0/16"]
}

# Create Subnet
resource "azurerm_subnet" "example" {
  name                 = "my-subnet"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Deploy VM with encryption
module "azure_vm" {
  source = "./path/to/module"

  vm_name             = "my-vm"
  region              = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  subnet_id           = azurerm_subnet.example.id
  environment         = "prod"
  data_disks_size_gb  = [64, 128]
  ssh_public_key      = file("~/.ssh/id_rsa.pub")
}
```

## Storage Type Selection

The module automatically selects the appropriate storage account type based on the `environment` variable:

| Environment | Storage Account Type | Use Case |
|-------------|---------------------|----------|
| `dev` | Standard_LRS | Development - Cost-effective HDD storage with local redundancy |
| `test` | Standard_LRS | Testing - Cost-effective HDD storage with local redundancy |
| `uat` | Standard_LRS | UAT - Cost-effective HDD storage with local redundancy |
| `pre-prod` | Premium_ZRS | Pre-production - High-performance SSD with zone redundancy |
| `prod` | Premium_ZRS | Production - High-performance SSD with zone redundancy |

This approach:
- Simplifies configuration (no need to choose storage types)
- Reduces costs for non-production environments
- Ensures production gets high-performance, zone-redundant storage
- Maintains consistency across deployments

## Security Considerations

1. **Disk Encryption**: All disks (OS and data) are encrypted using Azure Disk Encryption Sets with customer-managed keys
2. **Key Vault**: Keys are stored in Azure Key Vault with purge protection enabled
3. **SSH Authentication**: Password authentication is disabled; only SSH key authentication is allowed
4. **Network Security**: A Network Security Group is created and associated with the VM's network interface
5. **Managed Identity**: The Disk Encryption Set uses a system-assigned managed identity

## Component Details

### Key Vault Module
- Creates Azure Key Vault for encryption key storage
- Generates RSA 2048-bit encryption key
- Enables purge protection with 7-day retention
- Configures access policies for current user and disk encryption set

### Disk Encryption Set Module
- Creates disk encryption set with customer-managed keys
- Uses system-assigned managed identity
- Automatically configures Key Vault access policy

### Network Interface Module
- Creates network interface attached to provided subnet
- Creates and associates network security group
- Configures dynamic private IP allocation

### Virtual Machine Module
- Deploys Linux VM with encrypted OS disk
- SSH-only authentication (password disabled)
- Configurable VM size
- Uses hardcoded Ubuntu 22.04 LTS image (will be replaced with custom hardened image in future)

### Data Disks Module
- Creates encrypted managed disks based on size array
- Automatically attaches disks to VM with sequential LUN numbers
- All disks use the same storage account type

## Important Notes

- The Key Vault name includes a random suffix to ensure uniqueness across Azure
- Purge protection is enabled on the Key Vault with a 7-day retention period
- VNet and Subnet must be created outside this module
- Data disks are attached with LUN numbers starting from 0
- All disks (OS and data) use the same storage account type based on environment
- The module uses a clear separation of concerns with dedicated submodules for each component
- **VM Image is not configurable** - Currently uses Ubuntu 22.04 LTS, will be replaced with custom hardened image from repository in future

## Terraform Best Practices Implemented

1. **Input Validation**: All variables include validation rules
2. **Defaults**: Sensible defaults provided for optional variables
3. **Outputs**: Comprehensive outputs for integration with other modules
4. **Tagging**: Support for resource tagging
5. **Dependencies**: Explicit dependencies defined where needed
6. **Naming**: Consistent resource naming convention
7. **Security**: Sensitive variables marked appropriately
8. **Documentation**: Complete documentation with examples

## Cleanup

To destroy all resources:

```bash
terraform destroy
```

**Note**: Key Vaults with purge protection cannot be immediately deleted. They will be soft-deleted and can be recovered within the retention period (7 days by default).

To list and purge soft-deleted Key Vaults:

```bash
# List deleted Key Vaults
az keyvault list-deleted

# Purge a deleted Key Vault (if you have permissions)
az keyvault purge --name <KEY_VAULT_NAME>
```

## Troubleshooting

### Issue: VM Size Not Available in Region

**Error**: `SkuNotAvailable: The requested VM size ... is currently not available in location`

**Solution**: Try a different VM size or region. Check availability:

```bash
az vm list-skus --location eastus --size Standard_D --query "[?resourceType=='virtualMachines'].name" -o table
```

### Issue: Key Vault Name Already Exists

**Error**: `VaultAlreadyExists: The vault name '...' is already in use`

**Solution**: The Key Vault might be soft-deleted. Either:
1. Use a different VM name (which generates a different Key Vault name)
2. Purge the soft-deleted vault: `az keyvault purge --name <VAULT_NAME>`
3. Wait for the soft-delete retention period to expire

### Issue: Subnet and VM in Different Regions

**Error**: `InvalidResourceReference: ... both resources are in the same region`

**Solution**: Ensure the `region` variable matches the location of your VNet/subnet.

## Contributing

Contributions are welcome! Please ensure:

1. Code follows Terraform best practices
2. All variables are documented
3. Examples are provided for new features
4. Module has been tested in a real Azure environment

## License

This module is available under the MIT License.

## Author

Maintained by [patelajk2319-hcp](https://github.com/patelajk2319-hcp)

## Support

For issues and feature requests, please open an issue on GitHub.
