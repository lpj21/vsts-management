function Get-ReleaseDefinition {
	[CmdletBinding()]
    param($ReleaseDefinitionId,[Switch]$Complete)

    if ([string]::IsNullOrEmpty($ReleaseDefinitionId))
    {
        $releaseDefinitions = Invoke-ApiRequest -Method Get -Uri $VSTS.ReleaseDefinitions  
        if (-not $Complete){ return $releaseDefinitions.value }
        $releaseDefinitionsIds = $releaseDefinitions.value | Select -ExpandProperty id
    }
    else
    {
        $releaseDefinitionsIds = @($ReleaseDefinitionId)
    }

    $releaseDefinitionsIds | % {
        $cReleaseDefinitionId = $_
        $release = Invoke-ApiRequest -Method Get -Uri ($VSTS.ReleaseDefinition -f $cReleaseDefinitionId)  
        $release
    }    
}


