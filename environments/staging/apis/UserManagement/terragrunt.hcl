terraform {
  source = "../../../../modules/apis"
}

include {
  path = find_in_parent_folders()
}

dependency "parent" {
  config_path  = ".."
  skip_outputs = true
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
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
EOF
}

inputs = {
  folder_path         = get_terragrunt_dir()
  manifest            = "${get_terragrunt_dir()}/manifest.yaml"
  location            = "germanywestcentral"
  prefix              = "apim-staging"
  resource_group_name = dependency.parent.inputs.resource_group_name
  api_management_name = dependency.parent.inputs.api_management_name
  api_management_id   = dependency.parent.inputs.api_management_id
}