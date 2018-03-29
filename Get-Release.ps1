function Get-Release {
	[CmdletBinding()]
    param($ReleaseDefinitionId, $ReleaseId,$Top=25,[Switch]$Complete)

    if ([string]::IsNullOrEmpty($ReleaseDefinitionId))
    {
        $query = ""
    }
    else 
    {
        $query = "&definitionId=$($ReleaseDefinitionId)"
    }

    if ([string]::IsNullOrEmpty($releaseId))
    {
        $top = '$top=' + $Top
        $releases = Invoke-ApiRequest -Method Get -Uri "$($VSTS.Releases)$query&$top"  
        if (-not $Complete){ return $releases.value }
        $releaseIds = $releases.value | Select -ExpandProperty id
    }
    else
    {
        $releaseIds = @($releaseId)
    }

    $releaseIds | % {
        $cReleaseId = $_
        $release = Invoke-ApiRequest -Method Get -Uri ($VSTS.Release -f $cReleaseId)  
        $release
    }    
}