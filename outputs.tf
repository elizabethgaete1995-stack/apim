output "ams_name" {
  description = "The name of the API Management Service"
  value       = var.sku != "StandardV2" ? azurerm_api_management.ams[0].name : azapi_resource.apim[0].name
}

output "ams_sku_name" {
  description = "The name of the API Management Service"
  value       = var.sku != "StandardV2" ? azurerm_api_management.ams[0].sku_name : var.sku
}

output "ams_id" {
  description = "The ID of the API Management Service"
  value       = var.sku != "StandardV2" ? azurerm_api_management.ams[0].id : azapi_resource.apim[0].id
}

output "ams_gateway_url" {
  description = "The URL of the Gateway for the API Management Service"
  value       = var.sku != "StandardV2" ? azurerm_api_management.ams[0].gateway_url : null
}

output "ams_api_url" {
  description = "The URL for the Management API associated with this API Management service"
  value       = var.sku != "StandardV2" ? azurerm_api_management.ams[0].management_api_url : null
}

output "ams_public_ip_addresses" {
  description = "The Public IP addresses of the API Management Service"
  value       = var.sku != "StandardV2" ? azurerm_api_management.ams[0].public_ip_addresses : null
}

output "ams_private_ip_addresses" {
  description = "The Private IP addresses of the API Management Service"
  value       = var.sku != "StandardV2" ? azurerm_api_management.ams[0].private_ip_addresses : null
}

output "ams_api_id" {
  description = "The ID(s) of the API Management API(s)"
  value       = values(azurerm_api_management_api.ams_api).*.id
}

output "ams_backend_url" {
  description = "The URL(s) of the API Management Backend(s)"
  value       = values(azurerm_api_management_backend.ams_backend).*.url
}

output "ams_gateway_id" {
  description = "The ID(s) of the API Management Gateway(s)"
  value       = values(azurerm_api_management_gateway.ams_gateway).*.id
}