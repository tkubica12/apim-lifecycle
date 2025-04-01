resource "azapi_resource" "policy" {
  type = "Microsoft.ApiManagement/service/apis/policies@2024-06-01-preview"
  name = "policy"
  parent_id = azapi_resource.api.id

  body = {
    properties = {
      format = "xml"
      value = var.policy_content
    }
  }
}