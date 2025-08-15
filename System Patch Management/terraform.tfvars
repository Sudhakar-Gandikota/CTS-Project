resource_group_name = "rg-patch-mgmt"
location            = "Central US"
tags = {
  Project = "PatchMgmt"
  Owner   = "DevOps"
}

vm_id = "/subscriptions/<SUB_ID>/resourceGroups/<VM_RG>/providers/Microsoft.Compute/virtualMachines/<VM_NAME>"

# schedule overrides (optional)
schedule_start_time = "2025-08-17T02:00:00+05:30"
schedule_week_day   = "Sunday"
