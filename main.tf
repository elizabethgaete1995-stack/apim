resource "azurerm_api_management" "this" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name

  publisher_name  = var.publisher_name
  publisher_email = var.publisher_email

  sku_name                  = local.sku_name
  notification_sender_email = var.notification_sender_email
  min_api_version            = var.min_api_version

  public_network_access_enabled = var.public_network_access_enabled
  virtual_network_type          = local.effective_subnet_id == null ? "None" : var.virtual_network_type
  zones                         = length(var.zones) == 0 ? null : var.zones

  dynamic "virtual_network_configuration" {
    for_each = local.effective_subnet_id == null ? [] : [local.effective_subnet_id]

    content {
      subnet_id = virtual_network_configuration.value
    }
  }

  dynamic "identity" {
    for_each = var.identity == null ? [] : [var.identity]

    content {
      type         = identity.value.type
      identity_ids = length(identity.value.identity_ids) == 0 ? null : identity.value.identity_ids
    }
  }

  protocols {
    http2_enabled = var.protocols.http2_enabled
  }

  security {
    backend_ssl30_enabled  = var.security.backend_ssl30_enabled
    backend_tls10_enabled  = var.security.backend_tls10_enabled
    backend_tls11_enabled  = var.security.backend_tls11_enabled
    frontend_ssl30_enabled = var.security.frontend_ssl30_enabled
    frontend_tls10_enabled = var.security.frontend_tls10_enabled
    frontend_tls11_enabled = var.security.frontend_tls11_enabled
  }

  tags = local.tags

  timeouts {
    create = var.timeouts.create
    read   = var.timeouts.read
    update = var.timeouts.update
    delete = var.timeouts.delete
  }

  lifecycle {
    precondition {
      condition = !var.create_dedicated_vnet || contains([
        "StandardV2",
        "PremiumV2"
      ], var.sku.name)
      error_message = "La VNet dedicada implementada por este modulo usa integracion VNet v2 y requiere StandardV2 o PremiumV2. BasicV2 no soporta esta integracion."
    }

    precondition {
      condition     = !var.create_dedicated_vnet || var.subnet_id == null
      error_message = "No configure subnet_id cuando create_dedicated_vnet=true; el modulo creara y utilizara su propia subnet."
    }

    precondition {
      condition = (
        local.effective_subnet_id == null ||
        contains(["External", "Internal"], var.virtual_network_type)
      )
      error_message = "Cuando APIM utiliza una subnet, virtual_network_type debe ser External o Internal. Para StandardV2 use External."
    }

    precondition {
      condition = !(
        var.sku.name == "StandardV2" &&
        local.effective_subnet_id != null
      ) || var.virtual_network_type == "External"
      error_message = "StandardV2 con integracion VNet debe utilizar virtual_network_type=External; Internal corresponde a escenarios de inyeccion no soportados por StandardV2."
    }

    precondition {
      condition     = length(var.zones) == 0 || startswith(var.sku.name, "Premium")
      error_message = "zones solo debe configurarse con un SKU Premium/PremiumV2 compatible."
    }
  }

  depends_on = [
    azurerm_subnet_network_security_group_association.apim
  ]
}
