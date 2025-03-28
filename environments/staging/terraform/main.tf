resource "azurerm_resource_group" "main" {
  name     = "rg-${local.base_name}"
  location = var.location
}

resource "random_string" "main" {
  length  = 4
  special = false
  upper   = false
  numeric = false
  lower   = true
}

data "azurerm_client_config" "current" {}

data "azuread_client_config" "current" {}

module "base_infra" {
  source              = "../../../modules/base_infra"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  prefix              = var.prefix
  vnet_range          = "10.0.0.0/16"
}

module "apim" {
  source                                   = "../../../modules/apim"
  resource_group_name                      = azurerm_resource_group.main.name
  resource_group_id                        = azurerm_resource_group.main.id
  location                                 = azurerm_resource_group.main.location
  prefix                                   = var.prefix
  application_insights_id                  = module.base_infra.application_insights_id
  application_insights_instrumentation_key = module.base_infra.application_insights_instrumentation_key
  subnet_id                                = module.base_infra.subnet_apim_id
}

# Read the manifest.yaml file
data "local_file" "api_manifest" {
  filename = "${path.module}/../apis/Users/manifest.yaml"
}

locals {
  # Parse the YAML content
  manifest = yamldecode(data.local_file.api_manifest.content)

  # Get the list of APIs
  apis = local.manifest.apis
}

# Loop through each API in the manifest
module "apis" {
  source              = "../../../modules/api"
  for_each            = { for api in local.apis : "${api.shortName}-rev-${api.revision}" => api }
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  prefix              = var.prefix
  api_management_name = module.apim.api_management_name
  api_name            = each.value.shortName
  path                = each.value.prefix
  display_name        = each.value.name
  revision            = each.value.revision
  is_active_revision  = each.value.is_active_revision

  # Read the OpenAPI spec file
  openapi_content = file("${path.module}/../apis/Users/${each.value.openApiFile}")
}

