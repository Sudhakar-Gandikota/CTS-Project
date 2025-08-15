resource "azurerm_log_analytics_linked_service" "example" {
  resource_group_name = var.resource_group_name
  workspace_id        = var.workspace_id
  read_access_id      = var.automation_account_id
}

#Install Log Analytics (OMS) agent on Linux VM
resource "azurerm_virtual_machine_extension" "oms_agent_linux" {
  name                       = "OmsAgentForLinux"
  virtual_machine_id         = var.vm_id
  publisher                  = "Microsoft.EnterpriseCloud.Monitoring"
  type                       = "OmsAgentForLinux"
  type_handler_version       = "1.14"
  auto_upgrade_minor_version = true

  settings = jsonencode({
    workspaceId = var.workspace_guid
  })

  protected_settings = jsonencode({
    workspaceKey = var.workspace_key
  })
}


# Software Update Configuration (SUC) that targets the VM by resource id scope
resource "azurerm_automation_software_update_configuration" "suc" {
  name                    = var.update_config_name
  automation_account_id   = var.automation_account_id
  linux {
  classifications_included = ["Security"]
  excluded_packages        = ["apt"]
  included_packages        = ["vim"]
  reboot                   = "IfRequired"
  }
 
  schedule {
    frequency = "Week"
  }
  target {
    azure_query {
      scope = [var.vm_id]    # target this VM
    }
  }
}

output "suc_name"   { value = azurerm_automation_software_update_configuration.suc.name }