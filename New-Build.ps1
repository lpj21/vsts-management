function New-Build {
    [CmdletBinding()]
    param($BuildDefinitionId, $SourceBranch, $CommitId)

    $build = [PscustomObject]@{ definition = [PscustomObject]@{ id = $BuildDefinitionId ; }; sourceBranch = $SourceBranch; sourceVersion = $CommitId  } | ConvertTo-Json -Depth 100 -Compress
    Invoke-ApiRequest -Method Post -Uri $($VSTS.Builds -f $BuildDefinitionId) -Body $build
}