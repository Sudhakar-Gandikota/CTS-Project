variable "resource_group_name" { default = "rg-centralus-web" }
variable "location" { default = "Central US" }
variable "vm_size" { default = "Standard_B1s" }
variable "admin_username" { default = "azureuser" }
variable "ssh_public_key" { default = "~/.ssh/id_rsa.pub" }



variable "tags" {
  type    = map(string)
  default = {}
}

# Automation
variable "automation_account_name" {
  type    = string
  default = "autoacct-patch"
}

variable "automation_sku" {
  type    = string
  default = "Basic"
}

# Log Analytics
variable "log_analytics_name" {
  type    = string
  default = "law-patch"
}
variable "log_analytics_sku" {
  type    = string
  default = "PerGB2018"
}
variable "log_analytics_retention_days" {
  type    = number
  default = 30
}

# VM (existing)
variable "vm_id" {
  type = string
} # REQUIRED: resource id of the existing Linux VM

# Schedule
variable "schedule_name" {
  type    = string
  default = "weekly-linux-patch"
}
variable "schedule_timezone" {
  type    = string
  default = "Asia/Kolkata"
}
variable "schedule_start_time" {
  type    = string
  default = "2025-08-17T02:00:00+05:30"
} # RFC3339
variable "schedule_week_day" {
  type    = string
  default = "Sunday"
}

variable "update_config_name" {
  type    = string
  default = "linux-weekly-patch"
}
variable "linux_classifications" {
  type    = list(string)
  default = ["Security", "Critical"]
}
variable "reboot_setting" {
  type    = string
  default = "IfRequired"
}
variable "maintenance_window" {
  type    = string
  default = "PT2H"
}
