output "public_ip" {
  value = azurerm_public_ip.api.ip_address
}

output "vmid"{
  value =azurerm_linux_virtual_machine.alvm.id
}