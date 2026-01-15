# **Changelog**


## **[v2.7.4 (2024-12-23)]**
### Changes
- `Changed` Upgrade version of azurerm provider to 3.110.0 and 1.8.5 of Terraform
- `Updated` CHANGELOG.md.
- `Updated` README.md.

## **[v2.7.3 (2024-09-30)]**
### Changes
- `Added` Include StandardV2 option.
- `Updated` README.md
- `Updated` CHANGELOG.md

## **[v2.7.2 (2024-08-06)]**
### Changes
- `Added` availability zones for premium tier
- `Added` public ip resource
- `Updated` README.md
- `Updated` CHANGELOG.md

## **[v2.7.1 (2024-07-01)]**
### Changes
- `Updated` tfvars
- `Formatted` tfvars
- `Updated` control number of tags.
- `Updated` logic of diagnostic monitor.

## **[v2.7.0 (2024-05-28)]**
### Changes
- `Updated` Api Management resource.
- `Added` resource "azurerm_api_management_api" to create one or more apis.
- `Added` resource "azurerm_api_management_api_policy" to set api policies.
- `Added` resource "azurerm_api_management_certificate" to configure CA Cert in API Management.
- `Added` resource "azurerm_api_management_backend" to set one or more backends.
- `Added` resource "azurerm_api_management_gateway" to create one or more gateways.
- `Added` resource "azurerm_api_management_gateway_api" to set one or more gateways to one or more apis.
- `Added` resource "azurerm_key_vault_access_policy" Create an access policy to the Key Vault from the Api Management.
- `Added` resource "azurerm_api_management_custom_domain to configure one or more custom domains.
- `Added` resource "azurerm_api_management_identity_provider_aad" to configure AAD provider.
- `Added` resource "azurerm_api_management_authorization_server" to configure OAUTH.
- `Added` resource "azurerm_api_management_redis_cache" to connect an existing Redis Cache.
- `Added` customs tfvars.
- `Deleted` the tag obtaining method in local to call a dedicated tag module.
- `Changed` cia variable from optional to required.
- `Added` tags module call.
- `Added` optional_tags variable.
- `Updated` README.md
- `Updated` CHANGELOG.md



## **[v2.6.4 (2024-05-14)]**
### Changes
- `Tested` with terraform v1.7.1 and azure provider v3.90.0.
- `Updated` CHANGELOG.md.
- `Updated` README.md.

## **[v2.6.3 (2024-04-12)]**
- `Updated` Clean datas and depends_on. 
- `Updated` CHANGELOG.md.
    
## **[v2.6.2 (2024-03-13)]**
- `Changed` location variable from Required to Optional. 
- `Added` analytics_diagnostic_monitor_lwk_id variable.
- `Changed` lwk_name variable from Required to Optional.
- `Changed` lwk_rsg_name variable from Required to Optional.
- `Updated` azurerm_log_analytics_workspace datasource called lwk_principal.

## **[2.6.1 (2024-02-19)]**
- `Added` use sta & aeh in the diagnostic settings component.
- `Updated` azurerm_monitor_diagnostic_setting resource called mds_principal. 
- `Added` eventhub_authorization_rule_id variable.
- `Added` analytics_diagnostic_monitor_aeh_namespace variable.
- `Added` analytics_diagnostic_monitor_aeh_name variable.
- `Added` analytics_diagnostic_monitor_aeh_rsg variable. 
- `Added` analytics_diagnostic_monitor_aeh_policy variable.
- `Added` analytics_diagnostic_monitor_sta_id variable.
- `Added` analytics_diagnostic_monitor_sta_name variable.
- `Added` analytics_diagnostic_monitor_sta_rsg variable.
- `Updated` tags in locals variables and resources.
- `Updated` usage, configuration and links section in README.md
- `Updated` CHANGELOG.md.

## **[2.6.0 (2023-10-03)]**
### Changes
- `Update` README.md
- `Update` CHANGELOG.md
- `Update` versions terraform to  1.4.6 and Azure 3.60.0.

## **[v2.5.3 (2023-08-29)]**
- `Update` Delete retention policy block.
- `Update` README.md.

## **[2.5.2 (2023-06-23)]**
### Changes
- `Update` Solve bug with diagnostic settings monitor.
- 
## **[2.5.1 (2023-06-23)]**
### Changes
- `Update` Conditions in tag to apply new Naming Convention.

## **[2.5.0 (2023-03-01)]**
### Changes
- `Changed` name variable name in favour of ams_name.
- `Changed` resource_group variable name in favour of rsg_name.
- `Changed` lwk_resource_group_name variable name in favour of lwk_rsg_name.
- `Changed` analytics_diagnostic_monitor variable name in favour of analytics_diagnostic_monitor_name.
- `Changed` api_management_service_name output name in favour of ams_name 
- `Added` analytics_diagnostic_monitor_enabled variable.
- `Added` subnet_id variable.
- `Changed` old local tags in favour of new tags.
- `Changed` tags assign in resources from a merged group to local.tags.
- `Changed` rsg data name in favour of rsg_principal.
- `Changed` law data name in favour of lwk_principal.
- `Changed` monitor resource name in favour of mds_principal.
- `Update` Readme.md.
- `Update` module with template version v1.0.6.


## **[v2.4.0]** 
### Changes
- `Test` Terraform v1.3.2
- `Test` Re-apply

## **[v2.3.0]**
* Oficial Module terraform-azurerm-module-ams
* Terraform v1.0.9
* Azure provider 3.0.2
* Updated documentation
* First version without arm template
* Change file path CHANGELOG.md
* Add link [Build Status] Azure DevOps
* Update .gitignore
* Update README.md

## **[v2.2.1]**
### Changes
* Include custom tags and diagnostic settings
* Data Restructuring
* Last release iac.az.modules.ams
* Terraform v0.12.29
* Azure Provider 2.90

## **[v2.2.0]**
### Changes
* Updated terraform version and removed provider version
* Removed provider version
* Changed terraform version to ">= 0.12.29"
* The client is responsible for setting the versions in versions.tf
* Updated readme (description)
* Some other minor revisions (structure)

## **[v2.1.0]**
### Changes
* last version

## **[v2.1.0-beta.1]**
### Changes
* Set TF version 0.12.29

## **[v2.0.0-beta.1]**
### Changes
* Updated azurerm provider

## **[v1.1.0-beta.2]**
### Changes
* Update readme

## **[v1.1.0-beta.1]**
### Changes
* v1.1.0-beta.1

## **[v1.0.0]**
### Changes
* v1.0.0
