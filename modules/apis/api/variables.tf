variable "resource_group_name" {
  type        = string
  default     = "zentiva-rg"
  description = <<EOF
Name of the resource group to deploy resources.
EOF  
}

variable "location" {
  type        = string
  description = <<EOF
Azure region for resources.

Examples: swedencentral, westeurope, northeurope, germanywestcentral.
EOF
}

variable "prefix" {
  type        = string
  description = <<EOF
Prefix for resources.
Preferably 2-6 characters long without special characters, lowercase.
EOF
}

variable "api_management_name" {
  type        = string
  description = "Name of the API Management instance"
}

variable "path" {
  type        = string
  description = "API path"
}

variable "display_name" {
  type        = string
  description = "Display name for the API"
}

variable "revision" {
  type        = string
  description = "Revision number for the API"
}

variable "openapi_content" {
  type        = string
  description = "Content of the OpenAPI specification"
}

variable "policy_content" {
  type        = string
  description = "Content of the API policy" 
}

variable "api_name" {
  type        = string
  description = "Name for the API resource"
}

variable "is_active_revision" {
  type        = bool
  description = "Indicates if this is the active revision for the API"
}

variable "api_management_id" {
  description = "The ID of the API Management service"
  type        = string
}

variable "api_version" {
  description = "Version of the API Management service"
  type        = string
}

variable "version_set_id" {
  type        = string
  description = "The ID of the API version set"
}

