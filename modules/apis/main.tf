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
}

module "api" {
  source              = "./api"
  for_each            = { for api in local.apis : "${api.shortName}-rev-${api.revision}" => api }
  resource_group_name = var.resource_group_name
  location            = var.location
  prefix              = var.prefix
  api_management_name = var.api_management_name
  api_management_id   = var.api_management_id
  api_name            = "${each.value.shortName};rev=${each.value.revision}"
  path                = each.value.prefix
  display_name        = each.value.name
  revision            = each.value.revision
  is_active_revision  = each.value.is_active_revision
  openapi_content     = file("${var.folder_path}/${each.value.openApiFile}")
}
