# ============================================================
# APIM StandardV2 + VNet dedicada
# IMPORTANTE: reemplazar los CIDR de ejemplo por rangos aprobados
# y no superpuestos antes de ejecutar terraform apply.
# ============================================================

name                = "apim-contactcenter-prod-eastus-01"
resource_group_name = "rg-contactcenter-prod-eastus-01"
location            = "eastus2"

publisher_name  = "Metrogas S.A."
publisher_email = "jgestproy02@metrogas.cl"

notification_sender_email = "apimgmt-noreply@mail.windowsazure.com"

# BasicV2 no soporta VNet integration. Para mantener gateway publico
# y permitir conectividad privada hacia backends se utiliza StandardV2.
sku = {
  name     = "StandardV2"
  capacity = 1
}

public_network_access_enabled = true

# Para StandardV2, External representa la integracion VNet de salida.
# Los endpoints de gateway/developer portal permanecen publicos.
virtual_network_type = "External"

create_dedicated_vnet = false

vnet_name                = "Metrogas-dmz2-eastus-001"
vnet_resource_group_name = "Metrogas-connectivity-eastus"

# EJEMPLO. CAMBIAR POR EL CIDR APROBADO EN LA PLANIFICACION DE RED.
vnet_address_space = [
  "10.150.3.64/27"
]

# [] = DNS administrado por Azure.
vnet_dns_servers = []

subnet_name = "snet-api-management-dmz"

# Azure requiere minimo /27 y recomienda /24 para permitir escalamiento.
# EJEMPLO. CAMBIAR JUNTO CON vnet_address_space si corresponde.
subnet_address_prefixes = [
  "10.250.0.0/24"
]

nsg_name = "nsg-api-management-prd-eastus2-01"

identity = null

zones           = []
min_api_version = null

protocols = {
  http2_enabled = false
}

security = {
  backend_ssl30_enabled  = false
  backend_tls10_enabled  = false
  backend_tls11_enabled  = false
  frontend_ssl30_enabled = false
  frontend_tls10_enabled = false
  frontend_tls11_enabled = false
}

business_tags = {
  business_unit = "Management"
  workgroup     = "Sistemas"
  cost_center   = "IT"
  environment   = "PROD"
}

additional_tags = {}

timeouts = {
  create = "3h"
  read   = "5m"
  update = "3h"
  delete = "3h"
}
