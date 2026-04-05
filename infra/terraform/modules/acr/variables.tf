variable "name_prefix"              { type = string }
variable "resource_group"           { type = string }
variable "location"                 { type = string }
variable "tags"                     { type = map(string); default = {} }
variable "sku"                      { type = string; default = "Standard" }
variable "admin_enabled"            { type = bool; default = false }
variable "geo_replication_locations"{ type = list(string); default = [] }
