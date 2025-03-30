# Deploy version sets
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