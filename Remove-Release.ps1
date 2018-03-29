function Remove-Release {
    [CmdletBinding()]
    param([int]$ReleaseDefinitionId,[Parameter(Mandatory)][int]$ReleaseId)

    Invoke-ApiRequest -Method Delete -Uri ($VSTS.Release -f $ReleaseId)
}