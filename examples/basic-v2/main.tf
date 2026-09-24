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

  name                = "apim-callejero-prd-eastus-01"
  resource_group_name = "rg-callejero-prd-eastus-01"
  location            = "eastus2"

  publisher_name  = "Metrogas S.A."
  publisher_email = "jariquelme@metrogas.cl"

  sku = {
    name     = "BasicV2"
    capacity = 1
  }

  public_network_access_enabled = true
  virtual_network_type          = "None"
  subnet_id                     = null
  identity                      = null
  zones                         = []

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
    environment   = "DEV"
  }
}

output "apim_id" {
  value = module.apim.id
}

output "gateway_url" {
  value = module.apim.gateway_url
}
