function Start-ReleaseEnvironmentDeployment {
    [CmdletBinding()]
    param($ReleaseDefinitionId,$ReleaseId,$EnvironmentId)

    $result = Invoke-ApiRequest -Method Patch -Uri ($VSTS.Release -f "$ReleaseId/environments/$EnvironmentId") -Body (@{status = "inprogress"} | ConvertTo-Json)
}