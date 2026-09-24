# ============================================================
# Azure API Management - terraform.tfvars
# Baseline basado en APIM de referencia
# ============================================================

# ------------------------------------------------------------
# Identificacion del recurso
# ------------------------------------------------------------
name                = "apim-callejero-prd-eastus-01"
resource_group_name = "rg-callejero-prd-eastus-01"
location            = "eastus2"

# ------------------------------------------------------------
# Publisher
# ------------------------------------------------------------
publisher_name  = "Metrogas S.A."
publisher_email = "jariquelme@metrogas.cl"

# Remitente utilizado por APIM para notificaciones.
notification_sender_email = "apimgmt-noreply@mail.windowsazure.com"

# ------------------------------------------------------------
# SKU
# Equivalente al JSON:
#   name     = BasicV2
#   capacity = 1
# El modulo lo transforma internamente a BasicV2_1.
# ------------------------------------------------------------
sku = {
  name     = "BasicV2"
  capacity = 1
}

# ------------------------------------------------------------
# Networking
# Equivalente a:
#   publicNetworkAccess = Enabled
#   virtualNetworkType  = None
# ------------------------------------------------------------
public_network_access_enabled = true
virtual_network_type          = "None"
subnet_id                     = null

# ------------------------------------------------------------
# Managed Identity
# null replica el APIM de referencia, que no posee identidad.
# ------------------------------------------------------------
identity = null

# ------------------------------------------------------------
# Availability Zones
# El APIM BasicV2 de referencia no utiliza zonas.
# ------------------------------------------------------------
zones = []

# ------------------------------------------------------------
# API version constraint
# null replica minApiVersion = null.
# ------------------------------------------------------------
min_api_version = null

# ------------------------------------------------------------
# Protocolos
# JSON de referencia:
# Microsoft.WindowsAzure.ApiManagement.Gateway.Protocols.Server.Http2 = False
# ------------------------------------------------------------
protocols = {
  http2_enabled = false
}

# ------------------------------------------------------------
# Seguridad TLS / SSL
# TLS 1.0 y TLS 1.1 deshabilitados tanto en frontend como backend.
# SSL 3.0 deshabilitado.
# ------------------------------------------------------------
security = {
  backend_ssl30_enabled  = false
  backend_tls10_enabled  = false
  backend_tls11_enabled  = false

  frontend_ssl30_enabled = false
  frontend_tls10_enabled = false
  frontend_tls11_enabled = false
}

# ------------------------------------------------------------
# Tags corporativos obligatorios
# Se mantienen exactamente como aparecen en el JSON entregado.
# ------------------------------------------------------------
business_tags = {
  business_unit = "Management"
  workgroup     = "Sistemas"
  cost_center   = "IT"
  environment   = "DEV"
}

# ------------------------------------------------------------
# Tags adicionales opcionales
# ------------------------------------------------------------
additional_tags = {}

# ------------------------------------------------------------
# Timeouts
# APIM puede tardar bastante en operaciones create/update/delete.
# ------------------------------------------------------------
timeouts = {
  create = "3h"
  read   = "5m"
  update = "3h"
  delete = "3h"
}
