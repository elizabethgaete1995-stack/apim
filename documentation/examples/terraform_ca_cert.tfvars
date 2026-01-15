// COMMON VARIABLES
rsg_name = "sgtd2weursgitdmodcomm001"
location = "westeurope"
subscription_id = "ebac6c00-3c2f-4d56-82c0-8057225d44fa"

// KEY VAULT
akv_name = "sgtd2weuakvitdmodcomm002"

// PRODUCT
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

# Configure existing CA Cert
ca_name                = "prueba-cacert"
key_vault_secret_ca_id = "https://sgtd2weuakvitdmodcomm002.vault.azure.net/secrets/prueba-cacert/763e5e55ca1a4392a53201b5d48a5579"

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
