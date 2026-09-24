output "id" {
  description = "Resource ID de APIM."
  value       = azurerm_api_management.this.id
}

output "name" {
  description = "Nombre de APIM."
  value       = azurerm_api_management.this.name
}

output "gateway_url" {
  description = "URL publica del gateway de APIM."
  value       = azurerm_api_management.this.gateway_url
}

output "management_api_url" {
  description = "URL de Management API."
  value       = azurerm_api_management.this.management_api_url
}

output "public_ip_addresses" {
  description = "IPs publicas expuestas por el servicio, cuando aplique."
  value       = azurerm_api_management.this.public_ip_addresses
}

output "private_ip_addresses" {
  description = "IPs privadas expuestas por el servicio, cuando aplique."
  value       = azurerm_api_management.this.private_ip_addresses
}

output "principal_id" {
  description = "Principal ID de la Managed Identity System Assigned, si existe."
  value       = try(azurerm_api_management.this.identity[0].principal_id, null)
}

output "vnet_id" {
  description = "ID de la VNet dedicada creada por el modulo. null cuando se utiliza una red externa o no se usa VNet."
  value       = try(azurerm_virtual_network.apim[0].id, null)
}

output "subnet_id" {
  description = "Subnet efectiva utilizada por APIM."
  value       = local.effective_subnet_id
}

output "network_security_group_id" {
  description = "ID del NSG creado para la subnet dedicada."
  value       = try(azurerm_network_security_group.apim[0].id, null)
}
