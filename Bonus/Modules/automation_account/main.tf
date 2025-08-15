resource "azurerm_automation_account" "this" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku_name            = var.sku_name
  tags                = var.tags
}

output "automation_account_name" { value = azurerm_automation_account.this.name }
output "automation_account_id"   { value = azurerm_automation_account.this.id }
