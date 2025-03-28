# # resource "azurerm_api_management" "main" {
# #   name                = "apim-${local.base_name}"
# #   location            = azurerm_resource_group.main.location
# #   resource_group_name = azurerm_resource_group.main.name
# #   publisher_name      = "My Company"
# #   publisher_email     = "company@company.local"
# #   sku_name            = "Standardv2_1"
# # }

# resource "azapi_resource" "apim" {
#   type      = "Microsoft.ApiManagement/service@2023-09-01-preview"
#   name      = "apim-${local.base_name}"
#   parent_id = azurerm_resource_group.main.id

#   body = {
#     properties = {
#       apiVersionConstraint = {
#         minApiVersion = "2019-12-01"
#       }
#       # publicIpAddressId   = azurerm_public_ip.apim.id
#       publicNetworkAccess = "Enabled"
#       publisherName       = "My Company"
#       publisherEmail      = "company@company.local"
#       virtualNetworkType  = "External"

#       virtualNetworkConfiguration = {
#         subnetResourceId = azurerm_subnet.apim.id
#       }
#     }
#     location = azurerm_resource_group.main.location

#     sku = {
#       capacity = 1
#       name     = "StandardV2"
#     }
#   }
#   response_export_values = ["*"]
# }

# resource "azurerm_api_management_logger" "main" {
#   name                = "main"
#   api_management_name = azapi_resource.apim.name
#   resource_group_name = azurerm_resource_group.main.name
#   resource_id         = azurerm_application_insights.main.id

#   application_insights {
#     instrumentation_key = azurerm_application_insights.main.instrumentation_key
#   }
# }
