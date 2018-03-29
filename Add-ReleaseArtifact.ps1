function Add-ReleaseArtifact {
    [CmdletBinding()]
    param($ReleaseDefinitionId,$Artifact)
    process 
    {
        $releaseDefinition = Get-ReleaseDefinition -ReleaseDefinitionId $ReleaseDefinitionId
        $buildDefinition = Get-BuildDefinition -BuildDefinitionId $Artifact
        $project = Get-Project  -ProjectId $buid.project.id

        # Loop all artifacts and create a new list
        $newArtifacts = @()
        $releaseDefinition.artifacts | % { $newArtifacts += $_ }
        
        # Get last rank 
        $newArtifact = "{
                            `"id`":  0,
                            `"type`":  `"Build`",
                            `"alias`":  `"$($buildDefinition.name)`",
                            `"definitionReference`":  {
                                                        `"definition`":  {
                                                                           `"id`":  `"$($buildDefinition.id)`",
                                                                           `"name`":  `"$($buildDefinition.name)`"
                                                                       },
                                                        `"project`":  {
                                                                        `"id`":  `"$($project.id)`",
                                                                        `"name`":  `"$($project.name)`"
                                                                    }
                                                    }
                        }"

        $newArtifacts += ($newArtifact | ConvertFrom-Json)

        # Replace all artifacts with previous + new
        $releaseDefinition.artifacts = $newArtifacts

        Set-ReleaseDefinition -ReleaseDefinition $releaseDefinition
    }
}

