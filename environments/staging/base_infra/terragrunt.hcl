terraform {
  source = "../../../modules/base_infra"
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
    key                  = "apim-lifecycle-${path_relative_to_include() == "." ? basename(dirname(get_terragrunt_dir())) : split("/", path_relative_to_include())[0]}-${basename(get_terragrunt_dir())}.tfstate"
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

inputs = {
  location            = "germanywestcentral"
  prefix              = "apim-staging"
  vnet_range          = "10.0.0.0/16"
}
