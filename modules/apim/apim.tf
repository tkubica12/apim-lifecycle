resource "azapi_resource" "apim" {
  type      = "Microsoft.ApiManagement/service@2023-09-01-preview"
  name      = "apim-${local.base_name}"
  parent_id = var.resource_group_id
  location  = var.location

  body = {
    properties = {
      apiVersionConstraint = {
        minApiVersion = "2019-12-01"
      }
      # publicIpAddressId   = azurerm_public_ip.apim.id
      publicNetworkAccess   = "Enabled"
      publisherName         = "My Company"
      publisherEmail        = "company@company.local"
      virtualNetworkType    = "External"
      developerPortalStatus = "Enabled"

      virtualNetworkConfiguration = {
        subnetResourceId = var.subnet_id
      }
    }

    sku = {
      capacity = 1
      name     = "StandardV2"
    }
  }
  response_export_values = ["*"]
}

resource "azurerm_api_management_logger" "main" {
  name                = "main"
  api_management_name = azapi_resource.apim.name
  resource_group_name = var.resource_group_name
  resource_id         = var.application_insights_id

  application_insights {
    instrumentation_key = var.application_insights_instrumentation_key
  }
}
