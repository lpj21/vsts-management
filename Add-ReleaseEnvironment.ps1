function Add-ReleaseEnvironment {
    [CmdletBinding()]
    param($ReleaseDefinitionId,$Environment)

    $release = Get-ReleaseDefinition -ReleaseDefinitionId $ReleaseDefinitionId -Complete

    # Loop all environments and create a new list
    $newEnvironments = @()
    $release.environments | % { $newEnvironments += $_ }
    
    # Get last rank 
    $newRank = $release.environments | Measure-Object -Property rank -Maximum
   
    # Update the rank of the new environment
    $Environment.rank = $newRank.Maximum + 1

    $newEnvironments += $Environment

    # Replace all environments with previous + new
    $release.environments = $newEnvironments

    Set-ReleaseDefinition -ReleaseDefinition $release | Out-Null
}

