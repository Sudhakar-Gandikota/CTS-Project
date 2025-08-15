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
}

module "nsg" {
  source              = "./modules/nsg"
  nsg_name            = "centralus-nsg"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
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
}

output "vm_public_ip" {
  value = module.vm.public_ip
}
