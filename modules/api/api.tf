resource "azurerm_api_management_api" "api" {
  name                = var.api_name
  resource_group_name = var.resource_group_name
  api_management_name = var.api_management_name
  revision            = var.revision
  display_name        = var.display_name
  path                = var.path
  protocols           = ["https"]
  
  import {
    content_format = "openapi+json"
    content_value  = var.openapi_content
  }
}

# Deploy the API release if this is the active revision
resource "azurerm_api_management_api_release" "api_release" {
  count  = var.is_active_revision ? 1 : 0
  name   = "${var.api_name}-release"
  api_id = azurerm_api_management_api.api.id
}