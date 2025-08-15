variable "name"                { type = string }
variable "location"            { type = string }
variable "resource_group_name" { type = string }
variable "sku_name"            { 
    type = string 
    default = "Basic" 
}
variable "tags"                { 
    type = map(string) 
    default = {} 
}
