# Locals for environment-based storage configuration
locals {
  # dev, test, uat = Standard_LRS
  # pre-prod, prod = Premium_ZRS
  storage_account_type = contains(["dev", "test", "uat"], var.environment) ? "Standard_LRS" : "Premium_ZRS"
}
