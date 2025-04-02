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
    }
  }
}

# Get subscription secrets
resource "azapi_resource_action" "list_secrets" {
  for_each               = local.subscriptions
  type                   = "Microsoft.ApiManagement/service/subscriptions@2024-06-01-preview"
  resource_id            = azapi_resource.subscription[each.key].id
  action                 = "listSecrets"
  method                 = "POST"
  response_export_values = ["*"]
}

# Create Key Vault secrets for primary key
resource "azurerm_key_vault_secret" "primary_key_secret" {
  for_each     = local.subscriptions
  name         = each.value.keyvaultPrimarySecretName
  value        = azapi_resource_action.list_secrets[each.key].output.primaryKey
  key_vault_id = each.value.keyvaultId
}

# Create Key Vault secrets for secondary key
resource "azurerm_key_vault_secret" "secondary_key_secret" {
  for_each     = local.subscriptions
  name         = each.value.keyvaultSecondarySecretName
  value        = azapi_resource_action.list_secrets[each.key].output.secondaryKey
  key_vault_id = each.value.keyvaultId
}

