terraform {
  source = "../../../../modules/apim"
}

include {
  path = find_in_parent_folders()
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>4"
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "~>2"
    }
    azapi = {
      source  = "Azure/azapi"
      version = "~>2"
    }
    time = {
      source  = "hashicorp/time"
      version = "~>0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "rg-base"
    storage_account_name = "tomaskubicatf"
    container_name       = "tfstate"
    key                  = "apim-lifecycle-${basename(dirname(dirname(get_terragrunt_dir())))}-${basename(dirname(get_terragrunt_dir()))}-${basename(get_terragrunt_dir())}.tfstate"
    use_azuread_auth     = true
    subscription_id      = "673af34d-6b28-41dc-bc7b-f507418045e6"
  }
}

provider "azurerm" {
  subscription_id = "673af34d-6b28-41dc-bc7b-f507418045e6"
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
    key_vault {
      purge_soft_delete_on_destroy               = true
      purge_soft_deleted_secrets_on_destroy      = true
      purge_soft_deleted_certificates_on_destroy = true
      recover_soft_deleted_secrets               = true
      recover_soft_deleted_certificates          = true
      recover_soft_deleted_key_vaults            = true
    }

    api_management {
      purge_soft_delete_on_destroy = true
      recover_soft_deleted         = true
    }
  }
}

provider "random" {
  # Configuration options
}
EOF
}

dependency "infra" {
  config_path = "../infra"
}

inputs = {
  location                                 = "germanywestcentral"
  prefix                                   = "apim-staging"
  resource_group_name                      = dependency.infra.outputs.resource_group_name
  resource_group_id                        = dependency.infra.outputs.resource_group_id
  application_insights_id                  = dependency.infra.outputs.application_insights_id
  application_insights_instrumentation_key = dependency.infra.outputs.application_insights_instrumentation_key
  subnet_id                                = dependency.infra.outputs.subnet_apim_id
}