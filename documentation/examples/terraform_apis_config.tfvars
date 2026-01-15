// COMMON VARIABLES
rsg_name = "sgtd2weursgitdmodcomm001"
location = "westeurope"
subscription_id = "ebac6c00-3c2f-4d56-82c0-8057225d44fa"

// PRODUCT - API MANAGEMENT SETTINGS
ams_name        = "sgtd2weuamsitdmodcomm001-devbgt070624"
publisher_email = "x360392@santanderglobaltech.com"
publisher_name  = "Blanca"
sku             = "Developer" #"Developer", "Basic", "Standard", "Premium", "Consumption"
sku_count_basic = 2
# sku_count_standard      = 4
# sku_count_premium       = 10
subnet_id            = "/subscriptions/ebac6c00-3c2f-4d56-82c0-8057225d44fa/resourceGroups/sgtd2weursgitdmodcomm001/providers/Microsoft.Network/virtualNetworks/vnetprereq/subnets/lbtest"
virtual_network_type = "Internal" # "None", "Internal", "External"
# public_network_access_enabled = false
# ple_enabled                   = true

// KEY VAULT
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
  # "api5" = {
  #   name         = "api5"
  #   api_type     = "http"
  #   revision     = "2"
  #   path         = "path"
  #   protocols    = ["https"]
  #     import_url   = {
  #       content_format = "swagger-link-json"
  #       content_value  = "http://conferenceapi.azurewebsites.net/?format=json"
  #   }
  # }
}

# Gateways
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
    name_api     = "api2"
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
# optional_tags = {
#   entity            = "sgt"
#   #environment       = "dev"
#   #APM_technical     = "APM tech Test"
#   #business_service  = "Business Service Test"
#   #service_component = "Service Component Test"
#   #description       = "Description Test"
# }

# Custom tags
custom_tags = { "1" = "1", "2" = "2" }
