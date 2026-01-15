# Terraform and Azure Provider version being used
terraform {
  required_version = "= 1.8.5"
  required_providers {
    azurerm = {
      version = "= 3.110.0"
    }
    azuread = {
      version = "= 2.44.0"
    }
    azapi = {
      source  = "Azure/azapi"
      version = "1.13.1"
    }
    random = {
      version = ">= 3.6.0"
    }
    http = {
      version = ">= 3.4.0"
    }
  }
}
# Configure the Microsoft Azure Provider
provider "azurerm" {
  skip_provider_registration = true
  features {
    key_vault {
      purge_soft_delete_on_destroy               = false
      purge_soft_deleted_certificates_on_destroy = false
      purge_soft_deleted_keys_on_destroy         = false
      purge_soft_deleted_secrets_on_destroy      = false
      recover_soft_deleted_key_vaults            = true
      recover_soft_deleted_certificates          = true
      recover_soft_deleted_keys                  = true
      recover_soft_deleted_secrets               = true
      # Necessary to avoid errors in the destruction process with soft delete & recover 
    }
    template_deployment {
      delete_nested_items_during_deletion = true
      # use this feature only with a azurerm_template_deployment resource 
      # not necesarry with a azurerm_resource_group_template_deployment resource  
    }
  }
}