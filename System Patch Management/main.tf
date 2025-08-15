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

# resource group for Management artifacts
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
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

resource "azurerm_virtual_network" "example" {
  name                = "example-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}
 
resource "azurerm_subnet" "example" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.2.0/24"]
}
 
resource "azurerm_network_interface" "example" {
  name                = "example-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
 
  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.example.id
    private_ip_address_allocation = "Dynamic"
  }
}

# Example Linux VM (you should create your own or import an existing one)
resource "azurerm_linux_virtual_machine" "vm" {
  name                            = "patchvm"
  resource_group_name             = azurerm_resource_group.rg.name
  location                        = azurerm_resource_group.rg.location
  size                            = "Standard_B1s"
  admin_username                  = "azureuser"
  disable_password_authentication = true

  network_interface_ids = [
    azurerm_network_interface.example.id
  ]

  admin_ssh_key {
    username   = "azureuser"
    public_key = file("C:/Users/sudhakar Gandikota/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "20_04-lts"
    version   = "latest"
  }
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
  vm_id                   = azurerm_linux_virtual_machine.vm.id
  schedule_name           = var.schedule_name
  timezone                = var.schedule_timezone
  start_time              = var.schedule_start_time
  week_day                = var.schedule_week_day
  update_config_name      = var.update_config_name
  linux_classifications   = var.linux_classifications
  reboot_setting          = var.reboot_setting
  maintenance_window      = var.maintenance_window
}

output "suc_name" { value = module.update_mgmt.suc_name }