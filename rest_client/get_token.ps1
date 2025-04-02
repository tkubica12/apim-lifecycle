$accessToken = az account get-access-token --query accessToken -o tsv
[System.Environment]::SetEnvironmentVariable("ACCESS_TOKEN", $accessToken, [System.EnvironmentVariableTarget]::User)