resource_group_name = "rg-centralus-nginx"
location            = "Central US"
vm_size             = "Standard_B1s"
admin_username      = "azureuser"
ssh_public_key      = "C:/Users/sudhakar Gandikota/.ssh/id_rsa.pub"

tags = {
  Project = "PatchMgmt"
  Owner   = "DevOps"
}

vm_id = "/subscriptions/<SUB_ID>/resourceGroups/<VM_RG>/providers/Microsoft.Compute/virtualMachines/<VM_NAME>"

# schedule overrides (optional)
schedule_start_time = "2025-08-17T02:00:00+05:30"
schedule_week_day   = "Sunday"

