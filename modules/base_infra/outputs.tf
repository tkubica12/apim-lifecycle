output "subnet_apim_id" {
  value = azurerm_subnet.apim.id
}

output "subnet_private_endpoints_id" {
  value = azurerm_subnet.private_endpoints.id
}

output "vnet_id" {
  value = azurerm_virtual_network.main.id
}

output "vnet_name" {
  value = azurerm_virtual_network.main.name
}

output "application_insights_connection_string" {
  value     = azurerm_application_insights.main.connection_string
  sensitive = true
}

output "application_insights_id" {
  value = azurerm_application_insights.main.id
}

output "application_insights_instrumentation_key" {
  value     = azurerm_application_insights.main.instrumentation_key
  sensitive = true
}

output "log_workspace_resource_id" {
  value = azurerm_log_analytics_workspace.main.id
}

output "log_workspace_id" {
  value = azurerm_log_analytics_workspace.main.workspace_id
}

output "resource_group_name" {
  value = azurerm_resource_group.main.name
}

output "resource_group_id" {
  value = azurerm_resource_group.main.id
}


