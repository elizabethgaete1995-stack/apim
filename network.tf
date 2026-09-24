resource "azurerm_virtual_network" "apim" {
  count = var.create_dedicated_vnet ? 1 : 0

  name                = var.vnet_name
  location            = var.location
  resource_group_name = coalesce(var.vnet_resource_group_name, var.resource_group_name)
  address_space       = var.vnet_address_space
  dns_servers         = length(var.vnet_dns_servers) == 0 ? null : var.vnet_dns_servers

  tags = local.tags
}

resource "azurerm_network_security_group" "apim" {
  count = var.create_dedicated_vnet ? 1 : 0

  name                = var.nsg_name
  location            = var.location
  resource_group_name = coalesce(var.vnet_resource_group_name, var.resource_group_name)

  tags = local.tags
}

resource "azurerm_network_security_rule" "allow_storage_https" {
  count = var.create_dedicated_vnet ? 1 : 0

  name                        = "Allow-APIM-Storage-HTTPS-Out"
  priority                    = 100
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "Storage"
  resource_group_name         = coalesce(var.vnet_resource_group_name, var.resource_group_name)
  network_security_group_name = azurerm_network_security_group.apim[0].name
}

resource "azurerm_network_security_rule" "allow_keyvault_https" {
  count = var.create_dedicated_vnet ? 1 : 0

  name                        = "Allow-APIM-KeyVault-HTTPS-Out"
  priority                    = 110
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "AzureKeyVault"
  resource_group_name         = coalesce(var.vnet_resource_group_name, var.resource_group_name)
  network_security_group_name = azurerm_network_security_group.apim[0].name
}

resource "azurerm_subnet" "apim" {
  count = var.create_dedicated_vnet ? 1 : 0

  name                 = var.subnet_name
  resource_group_name  = coalesce(var.vnet_resource_group_name, var.resource_group_name)
  virtual_network_name = azurerm_virtual_network.apim[0].name
  address_prefixes     = var.subnet_address_prefixes

  delegation {
    name = "apim-v2-integration"

    service_delegation {
      name    = "Microsoft.Web/serverFarms"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
}

resource "azurerm_subnet_network_security_group_association" "apim" {
  count = var.create_dedicated_vnet ? 1 : 0

  subnet_id                 = azurerm_subnet.apim[0].id
  network_security_group_id = azurerm_network_security_group.apim[0].id
}
