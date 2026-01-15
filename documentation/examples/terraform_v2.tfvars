## DEPLOY ALL COMPONENTS INCLUDED IN THE MODULE

// COMMON VARIABLES
rsg_name = "sgtd2weursgitdmodcomm001"
location = "westeurope"
subscription_id = "ebac6c00-3c2f-4d56-82c0-8057225d44fa"

// PRODUCT
ams_name        = "sgtd2weuamsitdmodcomm309"
publisher_email = "n398810@santanderglobaltech.com"
publisher_name  = "Aida"
sku             = "StandardV2" #"Developer", "Basic", "Standard", "Premium", "Consumption"
sku_count_v2 = 3
#sku_count_basic = 2
# sku_count_standard      = 4
# sku_count_premium       = 10
subnet_id            = "/subscriptions/ebac6c00-3c2f-4d56-82c0-8057225d44fa/resourceGroups/sgtd2weursgitdmodcomm001/providers/Microsoft.Network/virtualNetworks/vnetprereq/subnets/afa-test-vnet-int"
virtual_network_type = "External" # "None", "Internal", "External"
# public_network_access_enabled = false
# ple_enabled                   = true

//KEY VAULT
akv_name = "sgtd2weuakvitdmodcomm002"

# Create and config APIS
create_apis_enabled = true

apis = {
  "api1" = {
    name      = "api1"
    api_type  = "http"
    revision  = "1"
    path      = "path"
    protocols = ["https"]
    import_url = {
      content_format = "swagger-link-json"
      content_value  = "https://store.swagger.io/v2/swagger.json"
    }
  },
  "api2" = {
    name      = "api2"
    api_type  = "soap"
    revision  = "2"
    path      = "path"
    protocols = ["https"]
    import_url = {
      content_format = "swagger-link-json"
      content_value  = "http://conferenceapi.azurewebsites.net/?format=json"
    }
  }
}

# Create and configure Gateways
create_gateways_enabled = true

gateways = {
  "gateway_1" = {
    name = "gateway_1"
    location_data = {
      name     = "Location 1"
      city     = "City 1"
      district = "District 1"
      region   = "Region 1"
    }
    description = "API Management Gateway 1"
  },
  "gateway_2" = {
    name = "gateway_2"
    location_data = {
      name     = "Location 2"
      city     = "City 2"
      district = "District 2"
      region   = "Region 2"
    }
    description = "API Management Gateway 2"
  },
}


# Bindings APIs - GATEWAYs
api_gateway = {
  "api1-gw1" = {
    name_api     = "api1"
    name_gateway = "gateway_1"
  },
  "api1-gw2" = {
    name_api     = "api1"
    name_gateway = "gateway_2"
  },
  "api2-gw2" = {
    name_api     = "api2"
    name_gateway = "gateway_2"
  },
}

# Apply API Policies
api_policy = {
  "api1" = {
    name        = "api1"
    xml_content = <<XML
<policies>
  <inbound>
    <find-and-replace from="xyz" to="abc" />
  </inbound>
</policies>
XML
  },
  "api2" = {
    name        = "api2"
    xml_content = <<XML
<policies>
    <inbound>
        <ip-filter action="forbid">
            <address-range from="10.10.10.1" to="10.10.10.2" />
        </ip-filter>
    </inbound>
</policies>
XML
  }
}

# Configure existing CA Cert
ca_name                = "prueba-cacert"
key_vault_secret_ca_id = "https://sgtd2weuakvitdmodcomm002.vault.azure.net/secrets/prueba-cacert/763e5e55ca1a4392a53201b5d48a5579"

# Create and configure Backends
api_backends = {
  "backend_1" = {
    name     = "backend_1"
    protocol = "http"
    url      = "https://backend1"
    #resource_id    = ""
  },
  "backend_2" = {
    name     = "backend_2"
    protocol = "soap"
    url      = "https://backend2"
    #resource_id    = ""
  },
}

# Create and configure Gateway Custom Domains with existing certificates
gateway_custom_domain = [
  {
    host_name    = "api-bgt.custom-domain.com"
    key_vault_id = "https://sgtd2weuakvitdmodcomm002.vault.azure.net/secrets/bgt-api-cert/c998b2f293ff41eabcede339bec3274f"
    #negotiate_client_certificate  = true
  },
  # {
  #   host_name                     = "api-bgt2.custom-domain.com"
  #   key_vault_id                  = "https://sgtd2weuakvitdmodcomm002.vault.azure.net/secrets/bgt-api-cert2/4b86ac6e1c534224a366dc19d36a4fb6"
  #   #negotiate_client_certificate  = true
  # },
]

# Create and configure  Developer Portal Custom Domains with existing certificates
# dev_portal_custom_domain = [
#   {
#     host_name                     = "devp1.custom-domain.com"
#     key_vault_id                  = "https://sgtd2weuakvitdmodcomm002.vault.azure.net/secrets/devp1-cert/c998b2f293ff41eabcede339bec3274f"
#     #negotiate_client_certificate  = true
#   },
#   {
#     host_name                     = "devp2.custom-domain.com"
#     key_vault_id                  = "https://sgtd2weuakvitdmodcomm002.vault.azure.net/secrets/devp2-cert/4b86ac6e1c534224a366dc19d36a4fb6"
#     #negotiate_client_certificate  = true
#   },
# ]

## AAD AUTH
# aad_enabled = false
# add_client_id =
# add_client_secret =
# oauth_enabled =

## OAUTH
# oauth_enabled = false
# oauth_server_name =
# oauth_display_name =
# oauth_client_id =
# authorization_endpoint =
# client_registration_endpoint =
# authorization_methods =
# oauth_client_secret =

## Redis Cache
# rch_enabled = true
# rch_name = "sgtd2weuredispremium-bgt-arc"
# connection_string = ""

// MONITOR DIAGNOSTICS SETTINGS
lwk_name                                   = "sgtd2weulwkitdmodcomm001"
lwk_rsg_name                               = "sgtd2weursgitdmodcomm001"
analytics_diagnostic_monitor_lwk_id        = "/subscriptions/ebac6c00-3c2f-4d56-82c0-8057225d44fa/resourceGroups/sgtd2weursgitdmodcomm001/providers/Microsoft.OperationalInsights/workspaces/sgtd2weulwkitdmodcomm002"
analytics_diagnostic_monitor_name          = "sgtd2weudgmitdmodcomm001-ddevbgt160224"
analytics_diagnostic_monitor_enabled       = true
analytics_diagnostic_monitor_sta_id        = "/subscriptions/ebac6c00-3c2f-4d56-82c0-8057225d44fa/resourceGroups/sgtd2weursgitdmodcomm001/providers/Microsoft.Storage/storageAccounts/sgtd2weustaitdmodcomm001"
analytics_diagnostic_monitor_sta_name      = "sgtd2weustaitdmodcomm001"
analytics_diagnostic_monitor_sta_rsg       = "sgtd2weursgitdmodcomm001"
analytics_diagnostic_monitor_aeh_rsg       = "sgtd2weursgitdmodcomm001"
analytics_diagnostic_monitor_aeh_namespace = "sgtd2weuaehitdmodcomm001"
analytics_diagnostic_monitor_aeh_name      = "sgtd2weuaehitdmodcomm001-testaeh"
#eventhub_authorization_rule_id             = "/subscriptions/2ce5e181-3cbf-417b-9dca-319bff83fbf5/resourceGroups/gscs1weursgsdhlchcomm001/providers/Microsoft.EventHub/namespaces/AEHTest/authorizationRules/RootManageSharedAccessKey"

// TAGGING
product        = "Product Test"
cost_center    = "CC-ITDMOD"
shared_costs   = "Yes"
apm_functional = "APM Test"
cia            = "CLL"

# Optional tags limited to 15
optional_tags = {
  entity            = "sgt"
  environment       = "dev"
  APM_technical     = "APM tech Test"
  business_service  = "Business Service Test"
  service_component = "Service Component Test"
  description       = "Description Test"
}

# Custom tags
custom_tags = { "1" = "1", "2" = "2" }