# Azure API Management lifecycle

This repository demonstrates managing the lifecycle of Azure API Management (APIM) APIs using Terraform and Terragrunt. It provides a structured approach to maintain APIs across different environments (e.g., staging, production).

## Project Structure

```
.
├── environments/                      # Environment-specific configurations
│   ├── prod/                          # Production environment
│   └── staging/                       # Staging environment
│       ├── apis/                      # API configurations for staging
│       │   ├── terragrunt.hcl         # Parent Terragrunt configuration for APIs
│       │   └── Users/                 # Example API implementation
│       │       ├── manifest.yaml      # API definition manifest
│       │       ├── terragrunt.hcl     # Terragrunt configuration for this API
│       │       ├── users.json         # OpenAPI specification file
│       │       └── users-policy.yaml  # API policies definition
│       ├── base/                      # Base components for staging
│       │   ├── terragrunt.hcl
│       │   ├── apim/                  # API Management instance config
│       │   │   └── terragrunt.hcl
│       │   └── infra/                 # Infrastructure components
│       │       └── terragrunt.hcl
│       └── base_infra/                # Base infrastructure
│           └── terragrunt.hcl
└── modules/                           # Reusable Terraform modules
    ├── apim/                          # API Management module
    │   ├── apim.tf
    │   ├── locals.tf
    │   ├── main.tf
    │   ├── outputs.tf
    │   └── variables.tf
    ├── apis/                          # APIs module
    │   ├── main.tf
    │   ├── outputs.tf
    │   ├── variables.tf
    │   └── api/                       # Individual API module
    │       ├── api.tf
    │       ├── main.tf
    │       └── variables.tf
    └── base_infra/                    # Base infrastructure module
        ├── locals.tf
        ├── main.tf
        ├── monitoring.tf
        ├── networking.tf
        ├── outputs.tf
        └── variables.tf
```

## Key Components

- **Terraform Modules**: Reusable Terraform modules for APIM, APIs, and infrastructure components.
- **Terragrunt**: Used for managing Terraform configurations across multiple environments, maintaining separate state files for each API.
- **OpenAPI Specifications**: APIs are defined using OpenAPI 3.0.3 specifications.
- **Manifest Files**: YAML files that describe API configurations, including references to OpenAPI specs and policies.

## Manifest-Based API Configuration

Each API is configured using a manifest file (manifest.yaml) that includes:
- OpenAPI specification file reference
- Policy file reference (for API-specific policies)
- API metadata (name, short name, prefix)
- Versioning and revision information
- Active revision status

Example manifest:
```yaml
apis:
- openApiFile: users.json
  policiesFile: users-policy.yaml
  name: Users
  shortName: users
  prefix: users
  version: "2025-01-01"
  revision: 1
  is_active_revision: true
```

### Versioning and Revision Information

APIs are versioned using a combination of `version` and `revision` fields in the manifest. The `version` field represents the API version (e.g., "2025-01-01"), while the `revision` field tracks changes within a version. The `is_active_revision` field indicates whether the revision is active.

Terraform modules automatically handle version sets and associate APIs with their respective versions and revisions.

## Usage

### Prerequisites

- Terraform
- Terragrunt
- Azure CLI (authenticated)

### Deploying APIs

Navigate to the desired environment and apply Terragrunt:

```bash
cd environments/staging/apis/Users
terragrunt init
terragrunt apply
```

You can also deploy all APIs in the staging environment by running:

```bash
cd environments/staging/apis
terragrunt run-all apply
```

### Updating APIs

Update the OpenAPI specification (users.json) or policies (users-policy.yaml) and re-apply Terragrunt to update the API:

```bash
terragrunt apply
```
