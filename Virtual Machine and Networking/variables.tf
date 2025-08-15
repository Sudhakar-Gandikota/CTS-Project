variable "resource_group_name" { default = "rg-centralus-web" }
variable "location" { default = "Central US" }
variable "vm_size" { default = "Standard_B1s" }
variable "admin_username" { default = "azureuser" }
variable "ssh_public_key" { default = "~/.ssh/id_rsa.pub" }
