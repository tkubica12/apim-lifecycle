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
  source = "../../../modules/apim"
  resource_group_name                      = azurerm_resource_group.main.name
  resource_group_id                        = azurerm_resource_group.main.id
  location                                 = azurerm_resource_group.main.location
  prefix                                   = var.prefix
  application_insights_id                  = module.base_infra.application_insights_id
  application_insights_instrumentation_key = module.base_infra.application_insights_instrumentation_key
  subnet_id                                = module.base_infra.subnet_apim_id
}

