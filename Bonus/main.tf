terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>4.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  resource_provider_registrations = "none"
  subscription_id                 = "c003d0f7-4f66-4eb7-b29e-6774115455ee"
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

module "vnet" {
  source              = "./modules/vnet"
  vnet_name           = "centralus-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_name         = "web-subnet"
  subnet_prefix       = ["10.0.1.0/24"]
  tags                = var.tags
}

module "nsg" {
  source              = "./modules/nsg"
  nsg_name            = "centralus-nsg"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  tags                = var.tags
}

module "vm" {
  source              = "./modules/linux-vm"
  vm_name             = "centralus-web"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  vm_size             = var.vm_size
  admin_username      = var.admin_username
  ssh_public_key      = var.ssh_public_key
  subnet_id           = module.vnet.subnet_id
  nsg_id              = module.nsg.nsg_id
  tags                = var.tags
}

output "vm_public_ip" {
  value = module.vm.public_ip
}

# Automation Account module
module "automation" {
  source              = "./modules/automation_account"
  name                = var.automation_account_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku_name            = var.automation_sku
  tags                = var.tags
}

# Log Analytics module
module "log_analytics" {
  source              = "./modules/log_analytics"
  name                = var.log_analytics_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = var.log_analytics_sku
  retention_in_days   = var.log_analytics_retention_days
  tags                = var.tags
}


# Update Management module: link and schedule
module "update_mgmt" {
  source                  = "./modules/update_management"
  resource_group_name     = azurerm_resource_group.rg.name
  automation_account_id   = module.automation.automation_account_id
  automation_account_name = module.automation.automation_account_name
  workspace_id            = module.log_analytics.workspace_id
  workspace_guid          = module.log_analytics.workspace_guid
  workspace_key           = module.log_analytics.workspace_key
  vm_id                   = module.vm.vmid
  schedule_name           = var.schedule_name
  timezone                = var.schedule_timezone
  start_time              = var.schedule_start_time
  week_day                = var.schedule_week_day
  update_config_name      = var.update_config_name
  linux_classifications   = var.linux_classifications
  reboot_setting          = var.reboot_setting
  maintenance_window      = var.maintenance_window
  schedule                = var.schedule
  tags                    = var.tags
}

output "suc_name" { value = module.update_mgmt.suc_name }