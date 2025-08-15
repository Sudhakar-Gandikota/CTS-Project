variable "resource_group_name"     { type = string }
variable "automation_account_id"   { type = string }
variable "automation_account_name" { type = string }
variable "workspace_id"            { type = string }
variable "workspace_guid"          { type = string }
variable "workspace_key"           { 
    type = string 
    sensitive = true 
}
variable "vm_id"                   { type = string }

variable "schedule_name"           { 
    type = string 
    default = "weekly-patch-schedule" 
}
variable "timezone"                { 
    type = string 
    default = "UTC" 
}
variable "start_time"              { type = string } # RFC3339 e.g. 2025-08-17T02:00:00Z
variable "week_day"                { 
    type = string 
    default = "Sunday" 
}

variable "update_config_name"      { 
    type = string 
    default = "linux-weekly-update" 
}
variable "linux_classifications"   { 
    type = list(string) 
    default = ["Security", "Critical"] 
}
variable "reboot_setting"          { 
    type = string 
    default = "IfRequired" 
} # IfRequired, Never, Always
variable "maintenance_window"      { 
    type = string 
    default = "PT2H" 
} # ISO8601 duration, e.g. PT2H (2 hours)
