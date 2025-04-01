resource "azapi_resource" "policy" {
  type      = "Microsoft.ApiManagement/service/products/policies@2024-06-01-preview"
  name      = "policy"
  parent_id = azapi_resource.product.id

  body = {
    properties = {
      format = "xml"
      value  = file(local.manifest.productPolicyFile)
    }
  }
}
