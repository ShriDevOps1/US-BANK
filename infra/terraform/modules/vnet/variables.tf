variable "name_prefix"        { type = string }
variable "resource_group"     { type = string }
variable "location"           { type = string }
variable "tags"               { type = map(string); default = {} }
variable "vnet_address_space" { type = list(string); default = ["10.0.0.0/16"] }
variable "aks_subnet_cidr"    { type = string; default = "10.0.1.0/24" }
variable "pod_subnet_cidr"    { type = string; default = "10.0.2.0/23" }
