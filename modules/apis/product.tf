resource "azapi_resource" "product" {
  type      = "Microsoft.ApiManagement/service/products@2024-06-01-preview"
  name      = local.manifest.productName
  parent_id = var.api_management_id
  body = {
    properties = {
      approvalRequired     = local.manifest.approvalRequired
      description          = local.manifest.productDescription
      displayName          = local.manifest.productDisplayName
      state                = "published"
      subscriptionRequired = true
      subscriptionsLimit   = 0
      terms                = local.manifest.productTerms
    }
  }
}


resource "azapi_resource" "api_link" {
  for_each  = local.unique_api_ids
  type      = "Microsoft.ApiManagement/service/products/apiLinks@2024-06-01-preview"
  name      = each.key
  parent_id = azapi_resource.product.id
  body = {
    properties = {
      apiId = each.value[0]
    }
  }

  depends_on = [
    module.api
  ]
}
