resource "azapi_resource" "dev_portal" {
  type      = "Microsoft.ApiManagement/service/portalRevisions@2024-06-01-preview"
  name      = "Rel-2025-04-02"
  parent_id = azapi_resource.apim.id
  body = {
    properties = {
      description = "My dev portal release"
      isCurrent   = true
    }
  }
}
