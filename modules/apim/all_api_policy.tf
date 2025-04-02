locals {
  all_api_policy = <<-EOF
<policies>
    <inbound>
        <cors allow-credentials="true">
            <allowed-origins>
                <origin>https://${azapi_resource.apim.location}.developer.azure-api.net</origin>
            </allowed-origins>
            <allowed-methods preflight-result-max-age="300">
                <method>*</method>
            </allowed-methods>
            <allowed-headers>
                <header>*</header>
            </allowed-headers>
            <expose-headers>
                <header>*</header>
            </expose-headers>
        </cors>
    </inbound>
    <backend>
        <forward-request />
    </backend>
    <outbound />
    <on-error />
</policies>
EOF
}

resource "azapi_resource" "all_api_policy" {
  type = "Microsoft.ApiManagement/service/policies@2024-06-01-preview"
  name = "policy"
  body = {
    properties = {
      format = "xml"
      value  = local.all_api_policy
    }
  }
}
