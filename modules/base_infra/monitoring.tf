resource "azurerm_log_analytics_workspace" "main" {
  name                = "logs-${local.base_name}"
  resource_group_name = azurerm_resource_group.main.name
  location            = var.location
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_application_insights" "main" {
  name                = "appi-${local.base_name}"
  resource_group_name = azurerm_resource_group.main.name
  location            = var.location
  application_type    = "web"
  workspace_id        = azurerm_log_analytics_workspace.main.id
}
