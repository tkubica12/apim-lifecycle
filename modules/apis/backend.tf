resource "azapi_resource" "backend" {
  for_each  = { for backend in local.backends : backend.name => backend }
  type      = "Microsoft.ApiManagement/service/backends@2024-06-01-preview"
  name      = each.key
  parent_id = var.api_management_id

  body = {
    properties = {
      url      = each.value.url
      protocol = "http"
    }
  }
}
