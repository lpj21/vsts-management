function Stop-ReleaseEnvironmentDeployment {
    [CmdletBinding()]
    param($ReleaseDefinitionId,$ReleaseId,$EnvironmentId)

    $result = Invoke-ApiRequest -Method Patch -Uri ($VSTS.Release -f "$ReleaseId/environments/$EnvironmentId") -Body (@{status = "canceled"} | ConvertTo-Json)  -ContentType "application/json"
}