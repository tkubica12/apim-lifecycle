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
│       │       ├── users.policy.xml   # API-level policy file
│       │       ├── product.policy.xml # Product-level policy file
│       │       └── subscriptions/     # Subscription definitions
│       │           ├── team1.yaml     # Example subscription definition for Team 1
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
    │   ├── main.tf                    # Main module for APIs and products
    │   ├── outputs.tf                 # Outputs for APIs and products
    │   ├── product.tf                 # Product resource definition
    │   ├── variables.tf               # Variables for APIs and products
    │   ├── version_set.tf             # API version set resource definition
    │   ├── policies.tf                # Policies for APIs and products
    │   ├── subscriptions.tf           # Subscriptions and keys
    │   └── api/                       # Individual API module
    │       ├── api.tf                 # API resource definition
    │       ├── main.tf                # Main module for individual APIs
    │       ├── variables.tf           # Variables for individual APIs
    │       └── policies.tf            # Policies for individual APIs
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
- Product-level policy file reference
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
productPolicyFile: product.policy.xml
approvalRequired: true
backends:
- name: httpbin
  url: https://httpbin.org/
apis:
- openApiFile: users.json
  policyFile: users.policy.xml
  name: Users
  shortName: users
  prefix: users
  version: "2025-01-01"
  revision: 1
  is_active_revision: true
```

### Policies

Policies can be applied at both the product and API levels to enforce rules, transformations, or restrictions.

- **Product-Level Policies**: Defined using the `productPolicyFile` attribute in the manifest. These policies apply to all APIs within the product.
- **API-Level Policies**: Defined using the `policyFile` attribute for each API in the manifest. These policies apply specifically to the individual API.

Both policy files should be written in XML format, following the Azure API Management policy schema.

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

### Subscriptions

Subscriptions can be defined individually using YAML files placed in the `subscriptions` folder within each API configuration directory. Each subscription YAML file should contain the following attributes:

- `name`: Unique identifier for the subscription.
- `displayName`: Human-readable name for the subscription.
- `allowTracing`: Boolean indicating whether tracing is enabled for the subscription.
- `keyVaultId`: Azure Key Vault resource ID where subscription keys will be stored.
- `primarySecretName`: Name of the secret in Key Vault for the primary subscription key.
- `secondarySecretName`: Name of the secret in Key Vault for the secondary subscription key.

Example subscription definition (`team1.yaml`):

```yaml
name: team1
displayName: Team 1
allowTracing: true
keyVaultId: /subscriptions/{subscription-id}/resourceGroups/{resource-group}/providers/Microsoft.KeyVault/vaults/{keyvault-name}
primarySecretName: team1-primary-key
secondarySecretName: team1-secondary-key
```

Terraform automatically picks up these subscription definitions, creates corresponding subscriptions in Azure API Management, and stores the generated subscription keys securely in the specified Azure Key Vault secrets.

## Process for API Changes on Pull Requests

When an API change is proposed via a Pull Request, two automated checks are triggered:

- **Security Check with Checkov**  
  This step scans changed OpenAPI specification files to detect security issues. If any issues are found, the GitHub Action automatically comments on the PR with the findings.

- **Breaking Change Detection with oasdiff**  
  This step analyzes changes in OpenAPI specs by comparing them against the main branch. It documents and highlights any potential breaking changes by posting a detailed report as a PR comment.

These automated checks ensure that any API modifications adhere to security policies and maintain backward compatibility.

## Usage

### Prerequisites

- Terraform
- Terragrunt
- Azure CLI (authenticated)

### Deploying APIs, Products, and Policies

Navigate to the desired environment and apply Terragrunt:

```bash
cd environments/staging/apis/UserManagement
terragrunt init
terragrunt apply
```

This will deploy the APIs, products, and their associated policies as defined in the manifest.

You can also deploy all APIs and products in the staging environment by running:

```bash
cd environments/staging/apis
terragrunt run-all apply
```

### Updating APIs, Products, or Policies

Update the OpenAPI specification (users.json), policies (users.policy.xml or product.policy.xml), or product metadata in the manifest (manifest.yaml) and re-apply Terragrunt to update the API, product, or policies:

```bash
terragrunt apply
```
