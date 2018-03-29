function Get-BuildDefinition {
	[CmdletBinding()]
    param($BuildDefinitionId,[switch]$Complete)

    if ([string]::IsNullOrEmpty($BuildDefinitionId))
    {
        $buildDefinitions = Invoke-ApiRequest -Method Get -Uri $VSTS.BuildDefinitions 
        if (-not $Complete){ return $buildDefinitions.value }
        $buildDefinitionsIds = $buildDefinitions.value | Select -ExpandProperty id   
    }
    else
    {
        $buildDefinitionsIds = @($BuildDefinitionId)
    }

    $buildDefinitionsIds | % {
        $cBuildDefinitionId = $_
        $buildDefinition = Invoke-ApiRequest -Method Get -Uri ($VSTS.BuildDefinition -f $cBuildDefinitionId)  
        $buildDefinition
    }    
}