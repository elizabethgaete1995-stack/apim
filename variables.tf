// COMMON VARIABLES
variable "rsg_name" {
  type        = string
  description = "(Required) The name of the resource group in which to create the API Management Service."
}

variable "location" {
  type        = string
  description = "(Optional) Specifies the supported Azure location where the resource exists. Changing this forces a new product to be created. If not set assumes the location of the rsg_name resource group."
  default     = null
}

variable "subscription_id" {
  type        = string
  description = "(Optional) Specifies the supported Azure subscription where the resource will be deployed. If it's not set, it assumes the current subscription id."
  default     = null
}

// COMMON KEY VAULT

variable "akv_id" {
  type        = string
  description = "(Optional) Specifies the Id of the common key vault.. It's required if akv_name is null."
  default     = null
}

variable "akv_rsg_name" {
  type        = string
  description = "(Optional) Specifies the name of the Resource Group where the key vault is located. If akv_id is set, it will be ignored. If akv_id is null and this variable is not set, it assumes the rsg_name value."
  default     = null
}

variable "akv_name" {
  type        = string
  description = "(Optional) Specifies the name of the common key vault. It is required if akv_id is null."
  default     = null
}

// PRODUCT
variable "ams_name" {
  type        = string
  description = "(Required) Specifies the name of the API Management Service. Changing this forces a new resource to be created. See CCoE Naming section for all restrictions."
}

variable "publisher_name" {
  type        = string
  description = "(Required) Specifies the name of the publisher/company."
}

variable "publisher_email" {
  type        = string
  description = "(Required) Specifies the email of the publisher/company."
}

variable "sku" {
  description = "(Required) The pricing tier of this API Management service"
  type        = string
  validation {
    condition     = contains(["Developer", "Basic", "Standard", "Premium", "Consumption", "StandardV2"], var.sku)
    error_message = "The sku must be one of the following: Developer, Basic, Standard, Premium, Consumption or StandardV2."
  }
}

variable "sku_count_v2" {
  description = "(Optional) The instance size of this API Management service with sku Standard. Required is sku variable is StandardV2"
  default     = 1
  type        = number
  validation {
    condition     = contains([1, 2, 3, 4], var.sku_count_v2)
    error_message = "The sku_count must be one of the following: 1, 2, 3, 4."
  }
}

variable "sku_count_basic" {
  description = "(Optional) The instance size of this API Management service with sku Basic. Required is sku variable is Basic"
  default     = 1
  type        = number
  validation {
    condition     = contains([1, 2], var.sku_count_basic)
    error_message = "The sku_count_basic must be one of the following: 1, 2."
  }
}

variable "sku_count_standard" {
  description = "(Optional) The instance size of this API Management service with sku Standard. Required is sku variable is Standard"
  default     = 1
  type        = number
  validation {
    condition     = contains([1, 2, 3, 4], var.sku_count_standard)
    error_message = "The sku_count must be one of the following: 1, 2, 3, 4."
  }
}

variable "sku_count_premium" {
  description = "(Optional) The instance size of this API Management service with sku Premium. The number of units must be a multiple of the number of availability zones. Change the number of units to properly configure availability zones. Required is sku variable is Premium"
  default     = 1
  type        = number
  validation {
    condition     = contains([1, 2, 3, 4, 5, 6, 7, 8, 9, 10], var.sku_count_premium)
    error_message = "The sku_count must be one of the following: 1, 2, 3, 4, 5, 6, 7, 8, 9, 10."
  }
}

variable "zones" {
  type        = list(string)
  description = "(Optional) A list of Availability Zones across which the SKU of the API Management service needs to be available. Availability zones are only supported in the Premium tier. The number of units must be a multiple of the number of availability zones. Change the number of units to properly configure availability zones. Changing this forces a new resource to be created."
  default     = null
}

variable "subnet_id" {
  type        = string
  description = "(Optional) The id of the subnet that will be used for the API Management. Only required if virtual_network_type is Internal or External."
  default     = null
}

variable "virtual_network_type" {
  type        = string
  description = "(Optional) The type of virtual network you want to use. Only required if sku is Developer or Premium. Allowed values: None, External, Internal."
  default     = "None"
}

variable "public_network_access_enabled" {
  type        = bool
  description = "(Optional) Flag to set if public network access is enabled or disabled. It can only be set to false if a private endpoint is used"
  default     = true
}
##################################
variable "public_ip" {
  type        = string
  description = "(Optional) Public IP Address for App Gateway. Required if availability zones are used in the Premiun sku ."
  default = null
}

variable "public_ip_zones" {
  type        = list(string)
  description = "(Optional) A collection containing the availability zone to allocate the Public IP."
  default     = null
}

variable "domain_name_label" {
  type        = string
  description = "(Optional) The domain name label for the public IP address. The concatenation of the domain name label and the regionalized DNS zone make up the fully qualified domain name associated with the public IP address. If a domain name label is specified, an A DNS record is created for the public IP in the Microsoft Azure DNS system."
  default     = null
}
################################
variable "create_apis_enabled" {
  type        = bool
  description = "(Optional) Flag to set if the API is created or no."
  default     = false
}

variable "apis" {
  type = map(object({
    name      = string
    api_type  = string
    revision  = string
    path      = string
    protocols = list(string)
    import = optional(object({
      content_format = string
      content_value  = string
    }))
  }))
  description = <<-DESCRIPTION
    (Optional) Array of objects defined by: 
      name         = "(Required) The name of the API Management API. Changing this forces a new API Management API to be created."
      api_type     = "(Required) The type of the API. Possible values are http, soap."
      revision     = "(Required) The revision number for the API. Changing this forces a new API Management API to be created."
      path         = "(Required) The path to the API."
      protocols    = "(Required) The protocols over which the API is made available. Possible values are http and/or https."
      import       = "(Optional) A import block defined by:
        content_format = (Required) The format of the imported API. Possible values are swagger-link-json, swagger-link-yaml, wadl-link-json, wadl-link-xml, wsdl-link, wsdl-link-json, wsdl-link-xml, openapi-link-json, openapi-link-yaml, openapi-link."
        content_value  = (Required) The URL of the link to the imported API."
  DESCRIPTION
  default     = {}
}

variable "create_gateways_enabled" {
  type        = bool
  description = "(Optional) Flag to set if the Gateway is created or no."
  default     = false
}

# Gateway
variable "gateways" {
  type = map(object({
    name = string
    location_data = object({
      name     = string
      city     = optional(string)
      district = optional(string)
      region   = optional(string)
    })
    description = optional(string)
  }))
  description = <<-DESCRIPTION
    (Optional) Array of gateways defined by: 
      name          = "(Required) The name which should be used for the API Management Gateway. Changing this forces a new API Management Gateway to be created."
      location_data = "(Required) A location_data block defined by:
        name     = (Required) A canonical name for the geographic or physical location.
        city     = (Optional) The city or locality where the resource is located.
        district = (Optional) The district, state, or province where the resource is located.
        region   = (Optional) The country or region where the resource is located."
      description   = "(Optional) The description of the API Management Gateway."
  DESCRIPTION
  default     = {}
}

variable "api_gateway" {
  type = map(object({
    name_api     = string
    name_gateway = string
  }))
  description = <<-DESCRIPTION
    (Optional) Array of objects defined by:
      name_api     = "(Required) The name of the API Management API. It must be the same value as the parameter name of the apis variable." 
      name_gateway = "(Required) The name of the API Management Gateway. It must be the same value as the parameter name of the gateways variable."
  DESCRIPTION
  default     = {}
}

variable "api_policy" {
  type = map(object({
    name        = string
    xml_content = string
  }))
  description = <<-DESCRIPTION
    (Optional) Array of objects defined by: 
      xml_content = "(Required) The XML content of the policy."
  DESCRIPTION
  default     = {}
}

# CA Cert
variable "cacert_enabled" {
  type        = bool
  description = "(Optional) Flag to set if the CA Cert is configured or no."
  default     = false
}
variable "ca_name" {
  type        = string
  description = "(Optional) The name of the API Management Certificate. Changing this forces a new resource to be created. Required if cacert_enabled is true."
  default     = null
}

variable "key_vault_secret_ca_id" {
  type        = string
  description = "(Optional) The ID of the Key Vault Secret containing the SSL Certificate, which must be of the type application/x-pkcs12.Required if cacert_enabled is true."
  default     = null
}

# Backend
variable "api_backends" {
  type = map(object({
    name        = string
    protocol    = string
    url         = string
    resource_id = optional(string)
  }))
  description = <<-DESCRIPTION
    (Optional) Array of backends defined by: 
      name        = "(Required) The name of the API Management backend. Changing this forces a new resource to be created."
      protocol    = "(Required) The protocol used by the backend host. Possible values are http or soap."
      url         = "(Required) The URL of the backend host."
      resource_id = "(Optional). The management URI of the backend host in an external system. This URI can be the ARM Resource ID of Logic Apps, Function Apps or API Apps, or the management endpoint of a Service Fabric cluster."
  DESCRIPTION
  default     = {}
}

## Private Endpoint
variable "ple_enabled" {
  type        = bool
  description = "(Optional) Flag to set if the Endpoint Service is used or no. If this variable is true, the virtual_network_type variable set to None."
  default     = false
}

## Custom domains
variable "gateway_custom_domain" {
  type = list(object({
    host_name                    = string
    key_vault_id                 = optional(string)
    negotiate_client_certificate = optional(bool)
    })
  )
  description = <<-DESCRIPTION
    (Optional) Array of objects defined by: 
      host_name                     = "(Optional). The name of the gateway host. Required if gateway_custom_domain variable is set."
      key_vault_id                  = "(Optional). Id of the ssl certificate secret (pkcs12) for the gateway cname."
      negotiate_client_certificate  = "(Optional). Set if client certificate negotiation should be enabled for this hostname." 
  DESCRIPTION
  default     = []
}

variable "dev_portal_custom_domain" {
  type = list(object({
    host_name                    = string
    key_vault_id                 = optional(string)
    negotiate_client_certificate = optional(bool)
    })
  )
  description = <<EOT
    (Optional) Array of objects defined by: 
      host_name                     = "(Optional). The name of the gateway host. Required if variable dev_portal_custom_domain variable is set."
      key_vault_id                  = "(Optional). Id of the ssl certificate secret (pkcs12) for the gateway cname."
      negotiate_client_certificate  = "(Optional). Set if client certificate negotiation should be enabled for this hostname." 
  EOT
  default     = []
}

## AAD AUTH
variable "aad_enabled" {
  type        = bool
  description = "(Optional) Flag to set if the Azure Active Directory is used or no."
  default     = false
}

variable "add_client_id" {
  type        = string
  description = "(Optional) Client Id of the Application in the AAD Identity Provider. Required if aad_enabled variable is true"
  default     = null
}
variable "add_client_secret" {
  type        = string
  description = "(Optional) Client secret of the Application in the AAD Identity Provider. Required if aad_enabled variable is true"
  default     = null
}

## OAUTH
variable "oauth_enabled" {
  type        = bool
  description = "(Optional) Flag to set if the oauth server is used or no."
  default     = false
}

variable "oauth_server_name" {
  type        = string
  description = "(Optional) The name of this Authorization Server. Changing this forces a new resource to be created. Required if oauth_enabled variable is true"
  default     = null
}

variable "oauth_display_name" {
  type        = string
  description = "(Optional) The user-friendly name of this Authorization Server. Required if oauth_enabled variable is true"
  default     = null
}

variable "oauth_client_id" {
  type        = string
  description = "(Optional) The Client/App ID registered with this Authorization Server. Required if oauth_enabled variable is true"
  default     = null
}

variable "authorization_endpoint" {
  type        = string
  description = "(Optional) The OAUTH Authorization Endpoint. Required if oauth_enabled variable is true"
  default     = null
}

variable "client_registration_endpoint" {
  type        = string
  description = "(Optional) The URI of page where Client/App Registration is performed for this Authorization Server. Required if oauth_enabled variable is true"
  default     = null
}

variable "authorization_methods" {
  type        = string
  description = "(Optional) The HTTP Verbs supported by the Authorization Endpoint. Possible values are DELETE, GET, HEAD, OPTIONS, PATCH, POST, PUT and TRACE. Required if oauth_enabled variable is true"
  default     = "GET"
}

variable "oauth_client_secret" {
  type        = string
  description = "(Optional) The Client/App Secret registered with this Authorization Server."
  default     = null
}

## Redis Cache
variable "rch_enabled" {
  type        = bool
  description = "(Optional) Flag to set if the Azure Active Directory is used or no."
  default     = false
}

variable "rch_name" {
  type        = string
  description = "(Optional) The name which should be used for this API Management Redis Cache. Changing this forces a new API Management Redis Cache to be created. Required if rch_enabled variable is true"
  default     = null
}

variable "connection_string" {
  type        = string
  description = "(Optional) The connection string to the Cache for Redis. Required if rch_enabled variable is true"
  default     = null
}

// MONITOR DIAGNOSTICS SETTINGS
variable "lwk_rsg_name" {
  type        = string
  description = "(Optional) The name of the resource group where the lwk is located. Only applies if analytics_diagnostic_monitor_enabled is true. If is not set, it assumes the rsg_name value. "
  default     = null
}

variable "analytics_diagnostic_monitor_lwk_id" {
  type        = string
  description = "(Optional) Specifies the Id of a Log Analytics Workspace where Diagnostics Data should be sent."
}

variable "lwk_name" {
  type        = string
  description = "(Optional) Specifies the name of a Log Analytics Workspace where Diagnostics Data should be sent."
  default     = null
}

variable "analytics_diagnostic_monitor_name" {
  type        = string
  description = "(Optional) The name of the diagnostic monitor. Required if analytics_diagnostic_monitor_enabled is true."
  default     = null
}

variable "analytics_diagnostic_monitor_enabled" {
  type        = bool
  description = "(Required) Flag to set if the diagnostic monitor is used or not. If the resource deploys in production env, the value will be ignored and asume for it a true value."
  default     = true
}

variable "eventhub_authorization_rule_id" {
  type        = string
  description = "(Optional) Specifies the id of the Authorization Rule of Event Hub used to send Diagnostics Data. Only applies if defined together with analytics_diagnostic_monitor_aeh_name."
  default     = null
}

variable "analytics_diagnostic_monitor_aeh_namespace" {
  type        = string
  description = "(Optional) Specifies the name of an Event Hub Namespace used to send Diagnostics Data. Only applies if defined together with analytics_diagnostic_monitor_aeh_name and analytics_diagnostic_monitor_aeh_rsg. It will be ignored if eventhub_authorization_rule_id is defined."
  default     = null
}

variable "analytics_diagnostic_monitor_aeh_name" {
  type        = string
  description = "(Optional) Specifies the name of the Event Hub where Diagnostics Data should be sent. Only applies if defined together with analytics_diagnostic_monitor_aeh_rsg and analytics_diagnostic_monitor_aeh_namespace or if defined together eventhub_authorization_rule_id."
  default     = null
}

variable "analytics_diagnostic_monitor_aeh_rsg" {
  type        = string
  description = "(Optional) Specifies the name of the resource group where the Event Hub used to send Diagnostics Data is stored. Only applies if defined together with analytics_diagnostic_monitor_aeh_name and analytics_diagnostic_monitor_aeh_namespace. It will be ignored if eventhub_authorization_rule_id is defined."
  default     = null
}

variable "analytics_diagnostic_monitor_aeh_policy" {
  type        = string
  description = "(Optional) Specifies the name of the event hub policy used to send diagnostic data. Defaults is RootManageSharedAccessKey."
  default     = "RootManageSharedAccessKey"
}

variable "analytics_diagnostic_monitor_sta_id" {
  type        = string
  description = "(Optional) Specifies the id of the Storage Account where logs should be sent."
  default     = null
}

variable "analytics_diagnostic_monitor_sta_name" {
  type        = string
  description = "(Optional) Specifies the name of the Storage Account where logs should be sent. If analytics_diagnostic_monitor_sta_id is not null, it won't be evaluated. Only applies if analytics_diagnostic_monitor_sta_rsg is not null and analytics_diagnostic_monitor_sta_id is null."
  default     = null
}

variable "analytics_diagnostic_monitor_sta_rsg" {
  type        = string
  description = "(Optional) Specifies the name of the resource group where Storage Account is stored. If analytics_diagnostic_monitor_sta_id is not null, it won't be evaluated. Only applies if analytics_diagnostic_monitor_sta_name is not null and analytics_diagnostic_monitor_sta_id is null."
  default     = null
}


// TAGGING
variable "inherit" {
  type        = bool
  description = "(Optional) Inherits resource group tags. Values can be false or true (by default)."
  default     = true
}

variable "product" {
  type        = string
  description = "(Required) The product tag will indicate the product to which the associated resource belongs to. In case shared_costs is Yes, product variable can be empty."
  default     = null
}

variable "cost_center" {
  type        = string
  description = "(Required) This tag will report the cost center of the resource. In case shared_costs is Yes, cost_center variable can be empty."
  default     = null
}

variable "shared_costs" {
  type        = string
  description = "(Optional) Helps to identify costs which cannot be allocated to a unique cost center, therefore facilitates to detect resources which require subsequent cost allocation and cost sharing between different payers."
  default     = "No"
  validation {
    condition     = var.shared_costs == "Yes" || var.shared_costs == "No"
    error_message = "Only `Yes`, `No` or empty values are allowed."
  }
}

variable "apm_functional" {
  type        = string
  description = "(Optional) Allows to identify to which functional application the resource belong, and its value must match with existing functional application code in Entity application portfolio management (APM) systems. In case shared_costs is Yes, apm_functional variable can be empty."
  default     = null
}

variable "cia" {
  type        = string
  description = "(Required) Allows a proper data classification to be attached to the resource."
  validation {
    condition     = length(var.cia) == 3 && contains(["C", "B", "A", "X"], substr(var.cia, 0, 1)) && contains(["L", "M", "H", "X"], substr(var.cia, 1, 1)) && contains(["L", "M", "C", "X"], substr(var.cia, 2, 1))
    error_message = "CIA must be a 3 character long and has to comply with the CIA nomenclature (CLL, BLM, AHM...). In sandbox this variable does not apply."
  }
  default = "XXX"
}

variable "optional_tags" {
  type = object({
    entity                = optional(string)
    environment           = optional(string)
    APM_technical         = optional(string)
    business_service      = optional(string)
    service_component     = optional(string)
    description           = optional(string)
    management_level      = optional(string)
    AutoStartStopSchedule = optional(string)
    tracking_code         = optional(string)
    Appliance             = optional(string)
    Patch                 = optional(string)
    backup                = optional(string)
    bckpolicy             = optional(string)
  })
  description = "(Optional) A object with the [optional tags](https://santandernet.sharepoint.com/sites/SantanderPlatforms/SitePages/Naming_and_Tagging_Building_Block_178930012.aspx?OR=Teams-HL&CT=1716801658655&clickparams=eyJBcHBOYW1lIjoiVGVhbXMtRGVza3RvcCIsIkFwcFZlcnNpb24iOiIyNy8yNDA1MDMwNTAwMCIsIkhhc0ZlZGVyYXRlZFVzZXIiOmZhbHNlfQ%3D%3D#optional-tags). These are: entity: (Optional) this tag allows to identify entity resources in a simpler and more flexible way than naming convention, facilitating cost reporting among others; environment: (Optional) this tag allows to identify to which environment belongs a resource in a simpler and more flexible way than naming convention, which is key, for example, to proper apply cost optimization measures; APM_technical: (Optional) this tag allows to identify to which technical application the resource belong, and its value must match with existing technical application code in entity application portfolio management (APM) systems; business_service: (Optional) this tag allows to identify to which Business Service the resource belongs, and its value must match with Business Service code in entity assets management systems (CMDB); service_component: (Optional) this tag allows to identify to which Service Component the resource belongs, and its value must match with Business Service code in entity assets management systems (CMDB); description: (Optional) this tag provides additional information about the resource function, the workload to which it belongs, etc; management_level: (Optional) this tag depicts the deployment model of the cloud service (IaaS, CaaS, PaaS and SaaS) and helps generate meaningful cloud adoption KPIs to track cloud strategy implementation, for example: IaaS vs. PaaS; AutoStartStopSchedule: (Optional) this tag facilitates to implement a process to automatically start/stop virtual machines according to a schedule. As part of global FinOps practice, there are scripts available to implement auto start/stop mechanisms; tracking_code: (Optional) this tag will allow matching of resources against other internal inventory systems; Appliance: (Optional) this tag identifies if the IaaS asset is an appliance resource. Hardening and agents installation cannot be installed on this resources; Patch: (Optional) this tag is used to identify all the assets operated by Global Public Cloud team that would be updated in the next maintenance window; backup: (Optional) used to define if backup is needed (yes/no value); bckpolicy: (Optional) (platinium_001 | gold_001 | silver_001 | bronze_001) used to indicate the backup plan required for that resource."
  default = {
    entity                = null
    environment           = null
    APM_technical         = null
    business_service      = null
    service_component     = null
    description           = null
    management_level      = null
    AutoStartStopSchedule = null
    tracking_code         = null
    Appliance             = null
    Patch                 = null
    backup                = null
    bckpolicy             = null
  }
}

variable "custom_tags" {
  type        = map(string)
  description = "(Optional) Custom tags for product."
  default     = {}
}