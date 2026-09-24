variable "name" {
  description = "Nombre del servicio Azure API Management."
  type        = string

  validation {
    condition     = length(var.name) >= 1 && length(var.name) <= 50 && can(regex("^[A-Za-z][A-Za-z0-9-]*[A-Za-z0-9]$|^[A-Za-z]$", var.name))
    error_message = "name debe tener entre 1 y 50 caracteres, comenzar con una letra y contener solo letras, numeros o guiones; no puede terminar en guion."
  }
}

variable "resource_group_name" {
  description = "Resource Group existente donde se desplegara APIM."
  type        = string
}

variable "location" {
  description = "Region de Azure donde se desplegara APIM, por ejemplo eastus2."
  type        = string
}

variable "publisher_name" {
  description = "Nombre del publisher de API Management."
  type        = string

  validation {
    condition     = length(var.publisher_name) > 0 && length(var.publisher_name) <= 100
    error_message = "publisher_name debe tener entre 1 y 100 caracteres."
  }
}

variable "publisher_email" {
  description = "Correo del publisher de API Management."
  type        = string

  validation {
    condition     = can(regex("^[^@\\s]+@[^@\\s]+\\.[^@\\s]+$", var.publisher_email)) && length(var.publisher_email) <= 100
    error_message = "publisher_email debe ser un correo valido de hasta 100 caracteres."
  }
}

variable "notification_sender_email" {
  description = "Correo remitente para notificaciones. null conserva el comportamiento administrado por Azure."
  type        = string
  default     = null
}

variable "sku" {
  description = "SKU y capacidad del servicio APIM. Para replicar el baseline usar BasicV2 con capacidad 1."
  type = object({
    name     = string
    capacity = number
  })

  default = {
    name     = "BasicV2"
    capacity = 1
  }

  validation {
    condition = contains([
      "Consumption",
      "Developer",
      "Basic",
      "BasicV2",
      "Standard",
      "StandardV2",
      "Premium",
      "PremiumV2"
    ], var.sku.name)
    error_message = "sku.name debe ser un SKU soportado por azurerm_api_management."
  }

  validation {
    condition = (
      var.sku.capacity == floor(var.sku.capacity) &&
      (var.sku.name == "Consumption" ? var.sku.capacity == 0 : var.sku.capacity >= 1)
    )
    error_message = "sku.capacity debe ser un entero. Consumption usa 0; los demas SKU deben usar 1 o superior."
  }
}

variable "public_network_access_enabled" {
  description = "Habilita acceso publico al plano de administracion. Azure requiere true durante la creacion del servicio."
  type        = bool
  default     = true
}

variable "virtual_network_type" {
  description = "Modo de red del APIM: None, External o Internal."
  type        = string
  default     = "None"

  validation {
    condition     = contains(["None", "External", "Internal"], var.virtual_network_type)
    error_message = "virtual_network_type debe ser None, External o Internal."
  }
}

variable "subnet_id" {
  description = "ID de subnet para APIM cuando virtual_network_type es External o Internal."
  type        = string
  default     = null
}

variable "identity" {
  description = "Managed Identity opcional. null reproduce el baseline sin identidad."
  type = object({
    type         = string
    identity_ids = optional(list(string), [])
  })
  default = null

  validation {
    condition = var.identity == null || contains([
      "SystemAssigned",
      "UserAssigned",
      "SystemAssigned, UserAssigned"
    ], var.identity.type)
    error_message = "identity.type debe ser SystemAssigned, UserAssigned o SystemAssigned, UserAssigned."
  }

  validation {
    condition = var.identity == null || (
      contains(["UserAssigned", "SystemAssigned, UserAssigned"], var.identity.type)
      ? length(var.identity.identity_ids) > 0
      : length(var.identity.identity_ids) == 0
    )
    error_message = "identity_ids debe informarse solo cuando identity.type incluye UserAssigned."
  }
}

variable "zones" {
  description = "Zonas de disponibilidad. Dejar [] para el baseline BasicV2."
  type        = list(string)
  default     = []
}

variable "min_api_version" {
  description = "Version minima de API del control plane. null replica el baseline mostrado."
  type        = string
  default     = null
}

variable "protocols" {
  description = "Protocolos habilitados en APIM."
  type = object({
    http2_enabled = optional(bool, false)
  })
  default = {}
}

variable "security" {
  description = "Baseline de seguridad TLS/SSL para frontend y backend."
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
  description = "Tags corporativos obligatorios."
  type = object({
    business_unit = string
    workgroup     = string
    cost_center   = string
    environment   = string
  })
}

variable "additional_tags" {
  description = "Tags adicionales. Los tags corporativos obligatorios prevalecen si existe colision."
  type        = map(string)
  default     = {}
}

variable "timeouts" {
  description = "Timeouts del recurso APIM."
  type = object({
    create = optional(string, "3h")
    read   = optional(string, "5m")
    update = optional(string, "3h")
    delete = optional(string, "3h")
  })
  default = {}
}

variable "create_dedicated_vnet" {
  description = "Crea una VNet, subnet delegada y NSG dedicados para la integracion de APIM v2. Requiere StandardV2 o PremiumV2."
  type        = bool
  default     = false
}

variable "vnet_name" {
  description = "Nombre de la VNet dedicada cuando create_dedicated_vnet=true."
  type        = string
  default     = null
}

variable "vnet_resource_group_name" {
  description = "Resource Group de la VNet. null utiliza el mismo Resource Group de APIM."
  type        = string
  default     = null
}

variable "vnet_address_space" {
  description = "Address space de la VNet dedicada."
  type        = list(string)
  default     = []
}

variable "vnet_dns_servers" {
  description = "DNS servers personalizados para la VNet. [] utiliza DNS administrado por Azure."
  type        = list(string)
  default     = []
}

variable "subnet_name" {
  description = "Nombre de la subnet dedicada a APIM."
  type        = string
  default     = null
}

variable "subnet_address_prefixes" {
  description = "CIDR de la subnet dedicada. Azure requiere minimo /27 y recomienda /24 para APIM v2."
  type        = list(string)
  default     = []
}

variable "nsg_name" {
  description = "Nombre del NSG asociado a la subnet dedicada de APIM."
  type        = string
  default     = null
}
