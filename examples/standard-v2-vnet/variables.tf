variable "name" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "publisher_name" {
  type = string
}

variable "publisher_email" {
  type = string
}

variable "notification_sender_email" {
  type    = string
  default = null
}

variable "sku" {
  type = object({
    name     = string
    capacity = number
  })
}

variable "public_network_access_enabled" {
  type = bool
}

variable "virtual_network_type" {
  type = string
}

variable "create_dedicated_vnet" {
  type = bool
}

variable "vnet_name" {
  type = string
}

variable "vnet_resource_group_name" {
  type    = string
  default = null
}

variable "vnet_address_space" {
  type = list(string)
}

variable "vnet_dns_servers" {
  type    = list(string)
  default = []
}

variable "subnet_name" {
  type = string
}

variable "subnet_address_prefixes" {
  type = list(string)
}

variable "nsg_name" {
  type = string
}

variable "identity" {
  type = object({
    type         = string
    identity_ids = optional(list(string), [])
  })
  default = null
}

variable "zones" {
  type    = list(string)
  default = []
}

variable "min_api_version" {
  type    = string
  default = null
}

variable "protocols" {
  type = object({
    http2_enabled = optional(bool, false)
  })
  default = {}
}

variable "security" {
  type = object({
    backend_ssl30_enabled  = optional(bool, false)
    backend_tls10_enabled  = optional(bool, false)
    backend_tls11_enabled  = optional(bool, false)
    frontend_ssl30_enabled = optional(bool, false)
    frontend_tls10_enabled = optional(bool, false)
    frontend_tls11_enabled = optional(bool, false)
  })
  default = {}
}

variable "business_tags" {
  type = object({
    business_unit = string
    workgroup     = string
    cost_center   = string
    environment   = string
  })
}

variable "additional_tags" {
  type    = map(string)
  default = {}
}

variable "timeouts" {
  type = object({
    create = optional(string, "3h")
    read   = optional(string, "5m")
    update = optional(string, "3h")
    delete = optional(string, "3h")
  })
  default = {}
}
