// COMMON VARIABLES
rsg_name = "sgtd2weursgitdmodcomm001"
location = "westeurope"
subscription_id = "ebac6c00-3c2f-4d56-82c0-8057225d44fa"

// KEY VAULT
akv_name = "sgtd2weuakvitdmodcomm002"

// PRODUCT
ams_name        = "sgtd2weuamsitdmodcomm001-devbgt310524"
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

# Create and configure Gateway Custom Domains with existing certificates
gateway_custom_domain = [
  {
    host_name    = "api-bgt.custom-domain.com"
    key_vault_id = "https://sgtd2weuakvitdmodcomm002.vault.azure.net/secrets/bgt-api-cert/c998b2f293ff41eabcede339bec3274f"
    #negotiate_client_certificate  = true
  },
  {
    host_name    = "api-bgt2.custom-domain.com"
    key_vault_id = "https://sgtd2weuakvitdmodcomm002.vault.azure.net/secrets/bgt-api-cert2/4b86ac6e1c534224a366dc19d36a4fb6"
    #negotiate_client_certificate  = true
  },
]

# Create and configure  Developer Portal Custom Domains with existing certificates
dev_portal_custom_domain = [
  {
    host_name    = "devp1.custom-domain.com"
    key_vault_id = "https://sgtd2weuakvitdmodcomm002.vault.azure.net/secrets/devp1-cert/c998b2f293ff41eabcede339bec3274f"
    #negotiate_client_certificate  = true
  },
  {
    host_name    = "devp2.custom-domain.com"
    key_vault_id = "https://sgtd2weuakvitdmodcomm002.vault.azure.net/secrets/devp2-cert/4b86ac6e1c534224a366dc19d36a4fb6"
    #negotiate_client_certificate  = true
  },
]

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

# Custom tags
custom_tags = { "1" = "1", "2" = "2" }
