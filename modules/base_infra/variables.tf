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

variable "vnet_range" {
  type        = string
  description = <<EOF
CIDR range for the virtual network.
EOF
}
