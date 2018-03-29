function Remove-ReleaseEnvironment {
    [CmdletBinding()]
    param($ReleaseDefinitionId,$EnvironmentId)

    $release = Get-ReleaseDefinition -ReleaseDefinitionId $ReleaseDefinitionId -Complete

    # Loop all environments and create a new list
    $newEnvironments = @()
    $release.environments | ? { $_.id -ne $EnvironmentId }  | % { $newEnvironments += $_ }
    
    # Replace all environments with previous - new
    $release.environments = $newEnvironments
	
	# Order ranks of env
	$rank = 1
	$release.environments | % { $_.rank = $rank++ }

    Set-ReleaseDefinition -ReleaseDefinition $release | Out-Null
}

