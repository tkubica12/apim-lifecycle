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

variable "folder_path" {
  type        = string
  description = "Path to folder"
}

variable "manifest" {
  type        = string
  description = "Path to manifest file"
}

variable "api_management_id" {
  description = "The ID of the API Management service"
  type        = string
}
