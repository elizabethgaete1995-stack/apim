locals {
  sku_name = "${var.sku.name}_${var.sku.capacity}"

  mandatory_tags = {
    BusinessUnit = var.business_tags.business_unit
    Workgroup    = var.business_tags.workgroup
    CostCenter   = var.business_tags.cost_center
    Environment  = var.business_tags.environment
  }

  tags = merge(var.additional_tags, local.mandatory_tags)

  effective_subnet_id = var.create_dedicated_vnet ? azurerm_subnet.apim[0].id : var.subnet_id
}
