resource "azurerm_log_analytics_workspace" "this" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.sku
  retention_in_days   = var.retention_in_days
  tags                = var.tags
}

# Install classic Update Management solution into the workspace
resource "azurerm_log_analytics_solution" "update_mgmt" {
  solution_name         = "UpdateManagement"
  location              = var.location
  resource_group_name   = var.resource_group_name
  workspace_resource_id = azurerm_log_analytics_workspace.this.id
  workspace_name        = azurerm_log_analytics_workspace.this.name

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/UpdateManagement"
  }
}

output "workspace_id"   { value = azurerm_log_analytics_workspace.this.id }
output "workspace_guid" { value = azurerm_log_analytics_workspace.this.workspace_id }
output "workspace_key"  { 
  value = azurerm_log_analytics_workspace.this.primary_shared_key 
  sensitive = true 
  }
