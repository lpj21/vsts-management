function Get-Build {
	[CmdletBinding()]
    param($BuildDefinitionId,$BuildId,$Top=25)

    if ([string]::IsNullOrEmpty($BuildId))
    {
        $top = '$top=' + $Top
        $builds = Invoke-ApiRequest -Method Get -Uri "$($VSTS.Builds)&definitions=$($BuildDefinitionId)&$top"  
        $builds.value
    }
    else
    {
        $build = Invoke-ApiRequest -Method Get -Uri ($VSTS.Build -f $BuildId)  
        $build
    }    
}