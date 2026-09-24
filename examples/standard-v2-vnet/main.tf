terraform {
  required_version = ">= 1.6.0, < 2.0.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.0, < 6.0"
    }
  }
}

provider "azurerm" {
  features {}
}

module "apim" {
  source = "../../"

  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location

  publisher_name             = var.publisher_name
  publisher_email            = var.publisher_email
  notification_sender_email = var.notification_sender_email

  sku                           = var.sku
  public_network_access_enabled = var.public_network_access_enabled
  virtual_network_type          = var.virtual_network_type

  create_dedicated_vnet   = var.create_dedicated_vnet
  vnet_name               = var.vnet_name
  vnet_resource_group_name = var.vnet_resource_group_name
  vnet_address_space      = var.vnet_address_space
  vnet_dns_servers        = var.vnet_dns_servers
  subnet_name             = var.subnet_name
  subnet_address_prefixes = var.subnet_address_prefixes
  nsg_name                = var.nsg_name

  identity        = var.identity
  zones           = var.zones
  min_api_version = var.min_api_version
  protocols       = var.protocols
  security        = var.security
  business_tags   = var.business_tags
  additional_tags = var.additional_tags
  timeouts        = var.timeouts
}

output "apim_id" {
  value = module.apim.id
}

output "gateway_url" {
  value = module.apim.gateway_url
}

output "vnet_id" {
  value = module.apim.vnet_id
}

output "subnet_id" {
  value = module.apim.subnet_id
}
