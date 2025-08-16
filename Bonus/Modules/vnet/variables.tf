variable "vnet_name" {}
variable "address_space" { type = list(string) }
variable "location" {}
variable "resource_group_name" {}
variable "subnet_name" {}
variable "subnet_prefix" { type = list(string) }
variable "tags"                { 
    type = map(string) 
    default = {} 
}