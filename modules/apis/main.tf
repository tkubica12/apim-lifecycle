terraform {
  required_providers {
    azapi = {
      source  = "azure/azapi"
      version = "~>2"
    }
  }
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

locals {
  manifest = yamldecode(file(var.manifest))
  apis     = local.manifest.apis
  unique_api_names = distinct([for api in local.apis : api.shortName])
}

// Deploy version sets
resource "azapi_resource" "version_set" {
  for_each  = toset(local.unique_api_names)
  type      = "Microsoft.ApiManagement/service/apiVersionSets@2024-06-01-preview"
  name      = "${each.value}-version-set"
  parent_id = var.api_management_id

  body = {
    properties = {
      versioningScheme  = "Header"
      versionHeaderName = "api-version"
      displayName       = each.value
    }
  }
}

module "api" {
  source              = "./api"
  for_each            = { for api in local.apis : "${api.shortName}-ver-${api.version}-rev-${api.revision}" => api }
  resource_group_name = var.resource_group_name
  location            = var.location
  prefix              = var.prefix
  api_management_name = var.api_management_name
  api_management_id   = var.api_management_id
  api_name            = "${each.value.shortName}-${each.value.version};rev=${each.value.revision}"
  path                = each.value.prefix
  display_name        = each.value.name
  revision            = each.value.revision
  is_active_revision  = each.value.is_active_revision
  openapi_content     = file("${var.folder_path}/${each.value.openApiFile}")
  api_version         = each.value.version
  version_set_id      = azapi_resource.version_set[each.value.shortName].id
}
