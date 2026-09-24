# terraform-azurerm-apim

Modulo estandarizado para desplegar Azure API Management desde Terraform Enterprise / HCP Terraform.

## Alcance

El modulo administra la infraestructura base de APIM. APIs, Products, Backends, Named Values y Policies se recomienda administrarlos en modulos separados para desacoplar su ciclo de vida del servicio APIM.

## Escenario actualizado: APIM con VNet dedicada

Para el escenario con VNet dedicada el modulo puede crear:

- Azure API Management `StandardV2_1`
- VNet dedicada
- Subnet exclusiva para APIM
- Delegacion de subnet a `Microsoft.Web/serverFarms`
- Network Security Group asociado
- Reglas outbound HTTPS hacia `Storage` y `AzureKeyVault`
- Managed Identity opcional
- Tags corporativos obligatorios

`BasicV2` no soporta VNet integration. Para conservar endpoints publicos y permitir que APIM alcance backends privados mediante una VNet se debe utilizar `StandardV2` o `PremiumV2`.

La subnet de integracion debe ser exclusiva para una instancia APIM. Azure exige como minimo `/27` y recomienda `/24` para permitir escalamiento.

## Uso

Ver el ejemplo completo:

```text
examples/standard-v2-vnet/
├── main.tf
├── variables.tf
├── terraform.tfvars
└── tfe-private-registry.tf.example
```

Ejemplo resumido:

```hcl
module "apim" {
  source = "./modules/apim"

  name                = "apim-callejero-prd-eastus-01"
  resource_group_name = "rg-callejero-prd-eastus-01"
  location            = "eastus2"

  publisher_name  = "Metrogas S.A."
  publisher_email = "jariquelme@metrogas.cl"

  sku = {
    name     = "StandardV2"
    capacity = 1
  }

  public_network_access_enabled = true
  virtual_network_type          = "External"

  create_dedicated_vnet    = true
  vnet_name                = "vnet-apim-callejero-prd-eastus2-01"
  vnet_address_space       = ["10.250.0.0/23"]
  subnet_name              = "snet-apim-integration-prd-eastus2-01"
  subnet_address_prefixes  = ["10.250.0.0/24"]
  nsg_name                 = "nsg-apim-callejero-prd-eastus2-01"

  identity = {
    type = "SystemAssigned"
  }

  business_tags = {
    business_unit = "Management"
    workgroup     = "Sistemas"
    cost_center   = "IT"
    environment   = "DEV"
  }
}
```

> Los CIDR anteriores son solamente ejemplos. Deben reemplazarse por rangos aprobados y sin superposicion antes del despliegue.

## Terraform Enterprise

Repositorio sugerido: `terraform-azurerm-apim`.

1. Publicar el repositorio en el VCS integrado con TFE.
2. Crear el modulo en el Private Module Registry.
3. Etiquetar releases con SemVer, por ejemplo `v1.1.0`.
4. Consumir el modulo desde los workspaces con una version fija.

```hcl
module "apim" {
  source  = "app.terraform.io/MI_ORGANIZACION/apim/azurerm"
  version = "1.1.0"

  # variables...
}
```

## Requisitos de permisos

La identidad utilizada por Terraform Enterprise necesita permisos para crear APIM y, cuando `create_dedicated_vnet=true`, para crear VNet, subnet, NSG y asociarlos. Para la integracion VNet, Azure requiere capacidad de `read` y `join/action` sobre la subnet. El resource provider `Microsoft.Web` debe estar registrado en la suscripcion para utilizar la delegacion `Microsoft.Web/serverFarms`.

## Networking existente

Si la VNet/subnet son administradas por otro modulo de red, usar:

```hcl
create_dedicated_vnet = false
subnet_id             = module.network.apim_subnet_id
virtual_network_type  = "External"
```

En ese caso, la subnet externa debe cumplir los mismos requisitos de dedicacion, tamanio, NSG y delegacion.

## Campos calculados por Azure

No se parametrizan campos de solo lectura o calculados por Azure como `etag`, `provisioningState`, `createdAtUtc`, `gatewayUrl`, `managementApiUrl`, hostname built-in, `platformVersion` o IPs calculadas. Los valores utiles se entregan como outputs.

## Recomendacion de composicion

Mantener repositorios/modulos independientes para APIM Service, APIs, Backends, Products, Named Values/Key Vault references, Policies, Diagnostics/Application Insights y Private Endpoints/DNS cuando correspondan.
