# Deploy API
resource "azapi_resource" "api" {
  type      = "Microsoft.ApiManagement/service/apis@2024-06-01-preview"
  name      = var.api_name
  parent_id = var.api_management_id

  body = {
    properties = {
      displayName = var.display_name
      apiRevision = var.revision
      path        = var.path
      protocols   = ["https"]
      format      = "openapi+json"
      value       = var.openapi_content
    }
  }
}

# Deploy the API release if this is the active revision
resource "azapi_resource" "api_release" {
  count     = var.is_active_revision ? 1 : 0
  type      = "Microsoft.ApiManagement/service/apis/releases@2024-06-01-preview"
  name      = "release-${var.revision}"
  parent_id = azapi_resource.api.id

  body = {
    properties = {
      apiId = azapi_resource.api.id
      notes = "Release for API ${var.display_name} revision ${var.revision}"
    }
  }
}
