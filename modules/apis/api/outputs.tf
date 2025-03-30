output "api_id" {
  description = "The ID of the API"
  value       = azapi_resource.api.id
}

output "short_name" {
  description = "The short name of the API"
  value       = split("-", split(";", var.api_name)[0])[0]
}

output "is_active" {
  description = "Indicates if this is the active revision"
  value       = var.is_active_revision
}
