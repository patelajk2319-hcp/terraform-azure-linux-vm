# Network Security Group
resource "azurerm_network_security_group" "this" {
  name                = var.nsg_name
  location            = var.region
  resource_group_name = var.resource_group_name

  tags = var.tags
}

# Network Interface
resource "azurerm_network_interface" "this" {
  name                = var.nic_name
  location            = var.region
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }

  tags = var.tags
}

# Network Interface Security Group Association
resource "azurerm_network_interface_security_group_association" "this" {
  network_interface_id      = azurerm_network_interface.this.id
  network_security_group_id = azurerm_network_security_group.this.id
}
