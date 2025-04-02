resource "azapi_resource" "subscription" {
  type      = "Microsoft.ApiManagement/service/subscriptions@2024-06-01-preview"
  for_each  = local.subscriptions
  parent_id = var.api_management_id
  name      = "${local.manifest.productName}-${each.value.name}"

  body = {
    properties = {
      allowTracing = each.value.allowTracing
      displayName  = "${local.manifest.productDisplayName} - ${each.value.displayName}"
      state        = "active"
      scope        = azapi_resource.product.id
      #   ownerId = each.value.ownerId
    }
  }
}
