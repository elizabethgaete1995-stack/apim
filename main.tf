terraform {
  required_providers {
    azapi = {
      source = "Azure/azapi"
      version = "= 1.13.1"
    }
  }
}
# Call Module Tags
module "tags" {
  source  = "tfe1.sgtech.corp/curated-catalog/module-tag/azurerm"
  version = ">=1.0.0"

  rsg_name       = var.rsg_name
  inherit        = var.inherit
  product        = var.product
  cost_center    = var.cost_center
  shared_costs   = var.shared_costs
  apm_functional = var.apm_functional
  cia            = var.cia
  custom_tags    = var.custom_tags
  optional_tags  = var.optional_tags
}

# Define variables for local scope
locals {

  diagnostic_monitor_enabled = substr(var.rsg_name, 3, 1) == "p" || var.analytics_diagnostic_monitor_enabled ? true : false
  mds_lwk_enabled            = var.analytics_diagnostic_monitor_lwk_id != null || (var.lwk_name != null && local.rsg_lwk != null)
  mds_sta_enabled            = var.analytics_diagnostic_monitor_sta_id != null || (var.analytics_diagnostic_monitor_sta_name != null && var.analytics_diagnostic_monitor_sta_rsg != null)
  mds_aeh_enabled            = var.analytics_diagnostic_monitor_aeh_name != null && (var.eventhub_authorization_rule_id != null || (var.analytics_diagnostic_monitor_aeh_namespace != null && var.analytics_diagnostic_monitor_aeh_rsg != null))

  subscription = var.subscription_id != null ? var.subscription_id : data.azurerm_client_config.current.subscription_id
  location     = var.location != null ? var.location : data.azurerm_resource_group.rsg_principal.location
  rsg_lwk      = var.lwk_rsg_name != null ? var.lwk_rsg_name : data.azurerm_resource_group.rsg_principal.name
  rsg_akv      = var.akv_rsg_name != null ? var.akv_rsg_name : data.azurerm_resource_group.rsg_principal.name
  akv_id       = var.akv_id != null ? var.akv_id : "/subscriptions/${local.subscription}/resourceGroups/${local.rsg_akv}/providers/Microsoft.KeyVault/vaults/${var.akv_name}"

  sku_capacity         = var.sku == "Basic" ? var.sku_count_basic : (var.sku == "Standard" ? var.sku_count_standard : (var.sku == "Premium" ? var.sku_count_premium : (var.sku == "Consumption" ? 0 : 1)))
  virtual_network_type = (var.sku == "Developer" || var.sku == "Premium") && !var.ple_enabled ? var.virtual_network_type : "None"

}

## DATAS
# Get info about curent session
data "azurerm_client_config" "current" {}

# Get and set a resource group for deploy. 
data "azurerm_resource_group" "rsg_principal" {
  name = var.rsg_name
}

# Get and set a monitor diagnostic settings
data "azurerm_log_analytics_workspace" "lwk_principal" {
  count = local.mds_lwk_enabled && var.analytics_diagnostic_monitor_lwk_id == null ? 1 : 0

  name                = var.lwk_name
  resource_group_name = local.rsg_lwk
}

data "azurerm_storage_account" "mds_sta" {
  count = local.mds_sta_enabled && var.analytics_diagnostic_monitor_sta_id == null ? 1 : 0

  name                = var.analytics_diagnostic_monitor_sta_name
  resource_group_name = var.analytics_diagnostic_monitor_sta_rsg
}

data "azurerm_eventhub_namespace_authorization_rule" "mds_aeh" {
  count = local.mds_aeh_enabled && var.eventhub_authorization_rule_id == null ? 1 : 0

  name                = var.analytics_diagnostic_monitor_aeh_policy
  resource_group_name = var.analytics_diagnostic_monitor_aeh_rsg
  namespace_name      = var.analytics_diagnostic_monitor_aeh_namespace
}

## RESOURCES

# Create and configure Public IP
resource "azurerm_public_ip" "public_ip" {
  count = var.zones != null && var.sku == "Premium" ? 1 : 0

  name                = var.public_ip
  resource_group_name = var.rsg_name
  location            = local.location
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = var.public_ip_zones
  domain_name_label   = var.domain_name_label
}

resource "azapi_resource" "apim" {
  count = var.sku == "StandardV2" && var.virtual_network_type != "Internal" ? 1 : 0
  type      = "Microsoft.ApiManagement/service@2023-03-01-preview"
  name      = var.ams_name
  parent_id = data.azurerm_resource_group.rsg_principal.id
  location  = local.location
  identity {
    type = "SystemAssigned"
  }

  body = {
    sku = {
      name     = var.sku
      capacity = var.sku_count_v2
    }
    zones = []
    properties = {
      publisherEmail        = var.publisher_email
      publisherName         = var.publisher_name
      apiVersionConstraint  = {}
      developerPortalStatus = "Disabled"
      virtualNetworkType    = var.virtual_network_type
      publicNetworkAccess  = "Enabled"
      virtualNetworkConfiguration = var.virtual_network_type == "External" ? {
        subnetResourceId = var.subnet_id
      } : null
    }
  }
}

# Create and configure Api Management Service
resource "azurerm_api_management" "ams" {
  count               = var.sku != "StandardV2" ? 1 : 0
  name                = var.ams_name
  location            = local.location
  resource_group_name = var.rsg_name
  publisher_name      = var.publisher_name
  publisher_email     = var.publisher_email
  sku_name            = "${var.sku}_${local.sku_capacity}"
  zones               = var.zones != null && var.sku == "Premium" ? var.zones : []

  identity {
    type = "SystemAssigned"
  }

  dynamic "virtual_network_configuration" {
    for_each = local.virtual_network_type != "None" && !var.ple_enabled ? [1] : []
    content {
      subnet_id = var.subnet_id
    }
  }

  virtual_network_type          = local.virtual_network_type
  public_network_access_enabled = var.public_network_access_enabled
  public_ip_address_id          = var.sku == "Premium" ? azurerm_public_ip.public_ip[0].id : null

  security {
    enable_backend_ssl30                                = "false"
    enable_backend_tls10                                = "false"
    enable_backend_tls11                                = "false"
    enable_frontend_ssl30                               = "false"
    enable_frontend_tls10                               = "false"
    enable_frontend_tls11                               = "false"
    tls_ecdhe_ecdsa_with_aes128_cbc_sha_ciphers_enabled = "false"
    tls_ecdhe_ecdsa_with_aes256_cbc_sha_ciphers_enabled = "false"
    tls_ecdhe_rsa_with_aes128_cbc_sha_ciphers_enabled   = "false"
    tls_ecdhe_rsa_with_aes256_cbc_sha_ciphers_enabled   = "false"
    tls_rsa_with_aes128_cbc_sha256_ciphers_enabled      = "false"
    tls_rsa_with_aes128_cbc_sha_ciphers_enabled         = "false"
    tls_rsa_with_aes128_gcm_sha256_ciphers_enabled      = "false"
    tls_rsa_with_aes256_cbc_sha256_ciphers_enabled      = "false"
    tls_rsa_with_aes256_cbc_sha_ciphers_enabled         = "false"
    triple_des_ciphers_enabled                          = "false"
  }

  tags                = var.inherit ? module.tags.tags : module.tags.tags_complete

}

# Create and configure APIs
resource "azurerm_api_management_api" "ams_api" {
  depends_on = [azapi_resource.apim, azurerm_api_management.ams]
  for_each = var.create_apis_enabled ? { for api in var.apis : api.name => api } : {}

  resource_group_name = var.rsg_name
  api_management_name = var.ams_name
  name                = each.key
  api_type            = each.value.api_type
  revision            = each.value.revision
  display_name        = each.value.name
  path                = "${each.key}/${each.value.path}"
  protocols           = each.value.protocols

  dynamic "import" {
    for_each = lookup(each.value, "import", null) == null ? [] : list(lookup(each.value, "import"))
    content {
      content_format = import.value.content_format
      content_value  = import.value.content_value
    }
  }
}

# Create and configure API Management API Policy
resource "azurerm_api_management_api_policy" "api_policy" {
  depends_on = [azapi_resource.apim, azurerm_api_management.ams]
  for_each = var.create_apis_enabled ? { for policy in var.api_policy : policy.name => policy } : {}

  api_name            = azurerm_api_management_api.ams_api[each.key].name
  api_management_name = var.ams_name
  resource_group_name = var.rsg_name

  xml_content = each.value.xml_content
}

# Configure API Management CA Cert from Key Vault
resource "azurerm_api_management_certificate" "ca_cert" {
  depends_on = [azapi_resource.apim, azurerm_api_management.ams]
  count               = var.cacert_enabled ? 1 : 0
  name                = var.ca_name
  api_management_name = var.ams_name
  resource_group_name = var.rsg_name

  key_vault_secret_id = var.key_vault_secret_ca_id
}

# Create and configure API Management Backend
resource "azurerm_api_management_backend" "ams_backend" {
  depends_on = [azapi_resource.apim, azurerm_api_management.ams]
  for_each            = var.api_backends
  resource_group_name = var.rsg_name
  api_management_name = var.ams_name
  name                = each.value.name
  protocol            = each.value.protocol
  url                 = each.value.url
  resource_id         = each.value.resource_id
}

# Create and configure API Management Gateway
resource "azurerm_api_management_gateway" "ams_gateway" {
  depends_on = [azurerm_api_management.ams]
  for_each = var.create_gateways_enabled && var.sku != "StandardV2" ? { for gateway in var.gateways : gateway.name => gateway } : {}

  name              = each.value.name
  api_management_id = "/subscriptions/${var.subscription_id}/resourceGroups/${var.rsg_name}/providers/Microsoft.ApiManagement/service/${var.ams_name}"
  description       = each.value.description

  location_data {

    name     = each.value.location_data.name
    city     = each.value.location_data.city
    district = each.value.location_data.district
    region   = each.value.location_data.region
  }
}

# Set the API to the Gateway and vice versa
resource "azurerm_api_management_gateway_api" "gateway_api" {
  depends_on = [azurerm_api_management.ams]
  for_each = var.create_apis_enabled && var.create_gateways_enabled && var.sku != "StandardV2" ? { for gateway in var.api_gateway : "${gateway.name_api}-${gateway.name_gateway}" => gateway } : {}

  api_id     = lookup(azurerm_api_management_api.ams_api, each.value.name_api).id
  gateway_id = lookup(azurerm_api_management_gateway.ams_gateway, each.value.name_gateway).id

  lifecycle {
    ignore_changes = [api_id]
  }

}

# Create an access policy to the Key Vault from the Api Management
resource "azurerm_key_vault_access_policy" "api2akv_access" {
  count = var.sku == "StandardV2" && var.virtual_network_type == "Internal" ? 0 : 1
  depends_on = [azapi_resource.apim, azurerm_api_management.ams]
  key_vault_id = local.akv_id
  tenant_id    = var.sku != "StandardV2" ? azurerm_api_management.ams[0].identity.0.tenant_id : azapi_resource.apim[0].identity.0.tenant_id 
  object_id    = var.sku != "StandardV2" ? azurerm_api_management.ams[0].identity.0.principal_id : azapi_resource.apim[0].identity.0.principal_id

  certificate_permissions = [
    "Get",
    "List",
  ]
  secret_permissions = [
    "Get",
    "List",
  ]
}

# Create a custom domain(s) to the Gateway
resource "azurerm_api_management_custom_domain" "gateway_custom_domain" {
  depends_on = [azurerm_api_management.ams]
  for_each          = { for index in var.gateway_custom_domain : index.host_name => index if var.gateway_custom_domain != [] &&  var.sku != "StandardV2"}
  api_management_id = "/subscriptions/${var.subscription_id}/resourceGroups/${var.rsg_name}/providers/Microsoft.ApiManagement/service/${var.ams_name}"

  gateway {
    host_name                    = each.value.host_name
    key_vault_id                 = each.value.key_vault_id
    negotiate_client_certificate = each.value.negotiate_client_certificate
  }

  timeouts {
    create = "2h"
    update = "2h"
    delete = "30m"
  }
}

# Create a custom domain(s) to the developer portal
resource "azurerm_api_management_custom_domain" "dev_portal_custom_domain" {
  depends_on = [azurerm_api_management.ams]
  for_each          = { for index in var.dev_portal_custom_domain : index.host_name => index if var.dev_portal_custom_domain != [] &&  var.sku != "StandardV2"}
  api_management_id = "/subscriptions/${var.subscription_id}/resourceGroups/${var.rsg_name}/providers/Microsoft.ApiManagement/service/${var.ams_name}"

  developer_portal {
    host_name                    = each.value.host_name
    key_vault_id                 = each.value.key_vault_id
    negotiate_client_certificate = each.value.negotiate_client_certificate
  }

  timeouts {
    create = "2h"
    update = "2h"
    delete = "30m"
  }

}

# Configure API Management AAD Identity Provider
resource "azurerm_api_management_identity_provider_aad" "provider_aad" {
  depends_on = [azapi_resource.apim, azurerm_api_management.ams]
  count = var.aad_enabled ? 1 : 0

  resource_group_name = var.rsg_name
  api_management_name = var.ams_name//azurerm_api_management.ams.name
  client_id           = var.add_client_id
  client_secret       = var.add_client_secret
  allowed_tenants     = [data.azurerm_client_config.current.tenant_id]
}

# Configure API Management Oauth Authentication
resource "azurerm_api_management_authorization_server" "oauth" {
  depends_on = [azapi_resource.apim, azurerm_api_management.ams]
  count = var.oauth_enabled ? 1 : 0

  name                         = var.oauth_server_name
  api_management_name          = var.ams_name
  resource_group_name          = var.rsg_name
  display_name                 = var.oauth_display_name
  client_id                    = var.oauth_client_id
  authorization_endpoint       = var.authorization_endpoint
  client_registration_endpoint = var.client_registration_endpoint
  client_secret                = var.oauth_client_secret

  grant_types = [
    "authorizationCode",
  ]
  authorization_methods = [
    var.authorization_methods #"GET", 
  ]
}

# Manages a API Management Redis Cache
resource "azurerm_api_management_redis_cache" "external_cache" {
  depends_on = [azapi_resource.apim, azurerm_api_management.ams]
  count = var.rch_enabled ? 1 : 0

  name              = var.rch_name
  api_management_id = "/subscriptions/${var.subscription_id}/resourceGroups/${var.rsg_name}/providers/Microsoft.ApiManagement/service/${var.ams_name}"
  connection_string = var.connection_string
}

resource "azurerm_monitor_diagnostic_setting" "mds_principal" {
  depends_on = [azapi_resource.apim, azurerm_api_management.ams]
  count = local.diagnostic_monitor_enabled ? 1 : 0

  name                           = var.analytics_diagnostic_monitor_name
  target_resource_id             = "/subscriptions/${var.subscription_id}/resourceGroups/${var.rsg_name}/providers/Microsoft.ApiManagement/service/${var.ams_name}"
  log_analytics_workspace_id     = local.mds_lwk_enabled ? (var.analytics_diagnostic_monitor_lwk_id != null ? var.analytics_diagnostic_monitor_lwk_id : data.azurerm_log_analytics_workspace.lwk_principal[0].id) : null
  eventhub_name                  = local.mds_aeh_enabled ? var.analytics_diagnostic_monitor_aeh_name : null
  eventhub_authorization_rule_id = local.mds_aeh_enabled ? (var.eventhub_authorization_rule_id != null ? var.eventhub_authorization_rule_id : data.azurerm_eventhub_namespace_authorization_rule.mds_aeh[0].id) : null
  storage_account_id             = local.mds_sta_enabled ? (var.analytics_diagnostic_monitor_sta_id != null ? var.analytics_diagnostic_monitor_sta_id : data.azurerm_storage_account.mds_sta[0].id) : null

  enabled_log {
    category = "GatewayLogs"
  }
  enabled_log {
    category = "WebSocketConnectionLogs"
  }

  metric {
    category = "AllMetrics"
  }
}
