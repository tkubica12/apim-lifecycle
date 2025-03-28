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

variable "application_insights_id" {
  type        = string
  description = "The ID of the Application Insights resource."
}

variable "application_insights_instrumentation_key" {
  type        = string
  description = "The instrumentation key for the Application Insights resource."
}

variable "subnet_id" {
  type        = string
  description = "The ID of the subnet for the APIM resource."
}

variable "resource_group_id" {
  type        = string
  description = "The ID of the resource group for the APIM resource."
}

