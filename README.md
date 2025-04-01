# Azure API Management lifecycle

This repository demonstrates managing the lifecycle of Azure API Management (APIM) APIs and products using Terraform and Terragrunt. It provides a structured approach to maintain APIs and products across different environments (e.g., staging, production).

## Project Structure

```
.
├── environments/                      # Environment-specific configurations
│   ├── prod/                          # Production environment
│   └── staging/                       # Staging environment
│       ├── apis/                      # API configurations for staging
│       │   ├── terragrunt.hcl         # Parent Terragrunt configuration for APIs
│       │   └── UserManagement/        # Example API implementation
│       │       ├── manifest.yaml      # API and product definition manifest
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
    ├── apis/                          # APIs and products module
    │   ├── main.tf
    │   ├── outputs.tf
    │   ├── product.tf                 # Product resource definition
    │   ├── variables.tf
    │   ├── version_set.tf             # API version set resource definition
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

- **Terraform Modules**: Reusable Terraform modules for APIM, APIs, products, and infrastructure components.
- **Terragrunt**: Used for managing Terraform configurations across multiple environments, maintaining separate state files for each API and product.
- **OpenAPI Specifications**: APIs are defined using OpenAPI 3.0.3 specifications.
- **Manifest Files**: YAML files that describe API and product configurations, including references to OpenAPI specs, policies, and product metadata.

## Manifest-Based Configuration

Each API and product is configured using a manifest file (manifest.yaml) that includes:
- Product metadata (name, display name, description, terms, approval requirements)
- Backend configurations (name, URL)
- OpenAPI specification file reference
- Policy file reference (for API-specific policies)
- API metadata (name, short name, prefix)
- Versioning and revision information
- Active revision status

Example manifest:
```yaml
productName: UserManagement
productDisplayName: User Management APIs
productDescription: User Management API for managing user accounts and profiles.
productTerms: |
  By using this API, you agree to the terms and conditions set forth by the API provider.
  Please refer to the API documentation for more details.
approvalRequired: true
backends:
- name: httpbin
  url: https://httpbin.org/
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

### Backends

Backends define the backend services that APIs connect to. Each backend is specified in the `backends` section of the manifest file with the following attributes:
- `name`: The name of the backend.
- `url`: The URL of the backend service.

These backends can be referenced in API configurations to route traffic to the appropriate service.

### Products

Products group APIs and define their access policies. The `product.tf` module handles the creation of products and their association with APIs. Products are defined in the manifest file and include metadata such as `productName`, `productDisplayName`, `productDescription`, and `productTerms`.

### Versioning and Revision Information

APIs are versioned using a combination of `version` and `revision` fields in the manifest. The `version` field represents the API version (e.g., "2025-01-01"), while the `revision` field tracks changes within a version. The `is_active_revision` field indicates whether the revision is active.

Terraform modules automatically handle version sets and associate APIs with their respective versions and revisions.

## Usage

### Prerequisites

- Terraform
- Terragrunt
- Azure CLI (authenticated)

### Deploying APIs and Products

Navigate to the desired environment and apply Terragrunt:

```bash
cd environments/staging/apis/UserManagement
terragrunt init
terragrunt apply
```

You can also deploy all APIs and products in the staging environment by running:

```bash
cd environments/staging/apis
terragrunt run-all apply
```

### Updating APIs or Products

Update the OpenAPI specification (users.json), policies (users-policy.yaml), or product metadata in the manifest (manifest.yaml) and re-apply Terragrunt to update the API or product:

```bash
terragrunt apply
```
