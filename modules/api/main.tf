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
