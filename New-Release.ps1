function New-Release {
    [CmdletBinding()]
    param($ReleaseDefinitionId,$Description)
    DynamicParam {
        $RuntimeParameterDictionary = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary
            
        if ($ReleaseDefinitionId)
        {
            $releaseDefinition = Get-ReleaseDefinition -ReleaseDefinitionId $ReleaseDefinitionId
        }
        
        $releaseDefinition.artifacts | % {
            $NameParam = $_.alias.Replace('.','_').Replace(' ','')
            $AttributeCollection = New-Object System.Collections.ObjectModel.Collection[System.Attribute]
                    
            $ParameterAttribute = New-Object System.Management.Automation.ParameterAttribute
            $ParameterAttribute.Mandatory = $true
            $AttributeCollection.Add($ParameterAttribute)
            
            Register-ArgumentCompleter -ParameterName $NameParam -ScriptBlock {
                # Very uygly way of getting all builds for each build definition
                # Should find a way to pass var value through the script block   
                param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameter)
                $releaseDefinition = Get-ReleaseDefinition -ReleaseDefinitionId $fakeBoundParameter["ReleaseDefinitionId"]

                $artifact = $releaseDefinition.artifacts | ? {$_.alias.Replace('.','_').Replace(' ','') -ieq $parameterName}
  
                Get-Build -BuildDefinitionId $artifact.definitionReference.definition.id -Top 100 | % { 
                    New-Object -TypeName System.Management.Automation.CompletionResult -ArgumentList @($_.id, "$($_.buildNumber) ($($_.sourceBranch))", [System.Management.Automation.CompletionResultType]::ParameterValue, "$($_.buildNumber) ($($_.sourceBranch))"); 
                }
            }
                
            $RuntimeParameter = New-Object System.Management.Automation.RuntimeDefinedParameter($NameParam, "int", $AttributeCollection)
            $RuntimeParameterDictionary.Add($NameParam, $RuntimeParameter)
        }

        if (($arrSet = $releaseDefinition.environments | ? { $_.conditions[0].name -eq "ReleaseStarted" } | Select -ExpandProperty name))
        {
            $ManualEnvironmentsParamName = "ManualEnvironments"
            $AttributeCollection = New-Object System.Collections.ObjectModel.Collection[System.Attribute]
                        
            $ParameterAttribute = New-Object System.Management.Automation.ParameterAttribute
            $AttributeCollection.Add($ParameterAttribute)

            
            $ValidateSetAttribute = New-Object System.Management.Automation.ValidateSetAttribute($arrSet)
                   
            $AttributeCollection.Add($ValidateSetAttribute) 
                   
            $RuntimeParameter = New-Object System.Management.Automation.RuntimeDefinedParameter($ManualEnvironmentsParamName, "System.Collections.Generic.List[string]", $AttributeCollection)
            $RuntimeParameterDictionary.Add($ManualEnvironmentsParamName, $RuntimeParameter)
        }
        
        return $RuntimeParameterDictionary
    }
    Process
    {
         
        $artifacts = $releaseDefinition.artifacts | % { 
            $buildId = $MyInvocation.BoundParameters[$_.alias.Replace('.','_').Replace(' ','')]
            $build = Get-Build -BuildId $buildId 
            [PsCustomObject]@{ 
                alias = $_.alias; 
                instanceReference = [PsCustomObject]@{ id =  $buildId; name =  $build.buildNumber; sourceBranch = $build.sourceBranch  } 
            }
        }

        $release = [PsCustomObject]@{
            "definitionId" = $ReleaseDefinitionId;
            "description" = $Description;
            "artifacts" = $artifacts;
            "manualEnvironments" = $MyInvocation.BoundParameters[$ManualEnvironmentsParamName]    
        }

        $release
        Invoke-ApiRequest -Method Post -Uri $VSTS.Releases  -Body ($release | ConvertTo-Json -Depth 100 -Compress) -ContentType "application/json"
    }
}