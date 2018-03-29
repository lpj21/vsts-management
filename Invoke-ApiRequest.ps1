function Invoke-ApiRequest {
    param(
    [string]$uri,
    [string]$method="GET",
    [string]$contentType="application/json; charset=utf-8",
    $body=$null)

    if (${VSTS-Bearer}) {
        Invoke-RestMethod -Method $method  -Uri $uri -Body $body -ContentType $contentType -Headers @{ "Authorization" =${VSTS-Bearer} }
    } else {
        Invoke-RestMethod -Method $method  -Uri $uri -Body $body -ContentType $contentType -UseDefaultCredentials:$UseDefaultCredentials
    }
}