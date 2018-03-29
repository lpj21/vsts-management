. $PSScriptRoot\Add-ReleaseArtifact.ps1
. $PSScriptRoot\Add-ReleaseEnvironment.ps1
. $PSScriptRoot\Copy-ReleaseEnvironment.ps1
. $PSScriptRoot\Copy-GitRepositories.ps1
. $PSScriptRoot\Get-Build.ps1
. $PSScriptRoot\Get-BuildDefinition.ps1
. $PSScriptRoot\Get-GitCommit.ps1
. $PSScriptRoot\Get-GitRefs.ps1
. $PSScriptRoot\Get-GitRepository.ps1
. $PSScriptRoot\Get-Project.ps1
. $PSScriptRoot\Get-Release.ps1
. $PSScriptRoot\Get-ReleaseDefinition.ps1
. $PSScriptRoot\Get-ServiceEndpoint.ps1
. $PSScriptRoot\Initialize-ServerInfo.ps1
. $PSScriptRoot\Invoke-ApiRequest.ps1
. $PSScriptRoot\New-Build.ps1
. $PSScriptRoot\New-Release.ps1
. $PSScriptRoot\Remove-Release.ps1
. $PSScriptRoot\Remove-ReleaseEnvironment.ps1
. $PSScriptRoot\Set-ReleaseDefinition.ps1
. $PSScriptRoot\Set-Project.ps1
. $PSScriptRoot\Start-ReleaseEnvironmentDeployment.ps1
. $PSScriptRoot\Stop-ReleaseEnvironmentDeployment.ps1


if ($PSVersionTable.PSCompatibleVersions | ? { $_.Major -eq 5 }) {
	Register-ArgumentCompleter -ParameterName "ReleaseDefinitionId" -ScriptBlock {   
		Get-ReleaseDefinition | Sort -Property name | % { 
			New-Object -TypeName System.Management.Automation.CompletionResult -ArgumentList @($_.id, $_.name, [System.Management.Automation.CompletionResultType]::ParameterValue, $_.name); 
		}
	}

	Register-ArgumentCompleter -ParameterName "ReleaseId" -ScriptBlock {   
		param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameter)
		
		Get-Release -ReleaseDefinitionId $fakeBoundParameter["ReleaseDefinitionId"] -Top 100 | Sort -Property name -Descending | % { 
			New-Object -TypeName System.Management.Automation.CompletionResult -ArgumentList @($_.id, "$($_.name)", [System.Management.Automation.CompletionResultType]::ParameterValue, $_.name); 
		}
	}
	Register-ArgumentCompleter -ParameterName "EnvironmentId" -ScriptBlock {   
		param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameter)
		
		$releaseDefinition = Get-ReleaseDefinition -ReleaseDefinitionId $fakeBoundParameter["ReleaseDefinitionId"] 
		$releaseDefinition.environments | Sort -Property name | % { 
			New-Object -TypeName System.Management.Automation.CompletionResult -ArgumentList @($_.id, "$($_.name)", [System.Management.Automation.CompletionResultType]::ParameterValue, $_.name); 
		}
	}
	Register-ArgumentCompleter -ParameterName "SourceBranch" -ScriptBlock {   
		param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameter)
		
		if (-not $fakeBoundParameter["BuildDefinitionId"]) { 
			$repositoryId = $fakeBoundParameter["RepositoryId"] 
		}
		else {
			$buildDefinition = Get-RmBuildDefinition -BuildDefinitionId $fakeBoundParameter["BuildDefinitionId"] 
			$repositoryId = $buildDefinition.repository.id
		}
		

		Get-GitRef -RepositoryId $repositoryId | % { 
			New-Object -TypeName System.Management.Automation.CompletionResult -ArgumentList @("`"$($_.name)`"", "$($_.name)", [System.Management.Automation.CompletionResultType]::ParameterValue, "$($_.name)");
		}
	}
	Register-ArgumentCompleter -ParameterName "CommitId" -ScriptBlock {   
		param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameter)
		
		if (-not $fakeBoundParameter["BuildDefinitionId"]) { 
			$repositoryId = $fakeBoundParameter["RepositoryId"] 
		}
		else {
			$buildDefinition = Get-RmBuildDefinition -BuildDefinitionId $fakeBoundParameter["BuildDefinitionId"] 
			$repositoryId = $buildDefinition.repository.id
		}
		
		Get-GitCommit -RepositoryId $repositoryId -SourceBranch $fakeBoundParameter["SourceBranch"] | % { 
			New-Object -TypeName System.Management.Automation.CompletionResult -ArgumentList @("`"$($_.commitId)`"", "$($_.comment)", [System.Management.Automation.CompletionResultType]::ParameterValue, "$($_.comment)");
		}
	}
	Register-ArgumentCompleter -ParameterName "BuildId" -ScriptBlock {   
		param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameter)
		
		Get-Build -BuildDefinitionId $fakeBoundParameter["BuildDefinitionId"] -Top 100 | % { 
			New-Object -TypeName System.Management.Automation.CompletionResult -ArgumentList @($_.id, "$($_.buildNumber) ($($_.sourceBranch))", [System.Management.Automation.CompletionResultType]::ParameterValue, "$($_.buildNumber) ($($_.sourceBranch))"); 
		}
	}
	Register-ArgumentCompleter -ParameterName "BuildDefinitionId" -ScriptBlock {   
		Get-BuildDefinition | Sort -Property name | % { 
			New-Object -TypeName System.Management.Automation.CompletionResult -ArgumentList @($_.id, $_.name, [System.Management.Automation.CompletionResultType]::ParameterValue, $_.name); 
		}
	}
	Register-ArgumentCompleter -ParameterName "Artifact" -ScriptBlock {   
		Get-BuildDefinition | Sort -Property name | % { 
			New-Object -TypeName System.Management.Automation.CompletionResult -ArgumentList @($_.id, $_.name, [System.Management.Automation.CompletionResultType]::ParameterValue, $_.name); 
		}
	}
	Register-ArgumentCompleter -ParameterName "ProjectId" -ScriptBlock {   
		Get-Project | Sort -Property name | % { 
			New-Object -TypeName System.Management.Automation.CompletionResult -ArgumentList @($_.id, $_.name, [System.Management.Automation.CompletionResultType]::ParameterValue, $_.name); 
		}
	}

	Register-ArgumentCompleter -ParameterName "ServiceEndpointId" -ScriptBlock {   
		Get-ServiceEndpoint | Sort -Property name | % { 
			New-Object -TypeName System.Management.Automation.CompletionResult -ArgumentList @($_.id, $_.name, [System.Management.Automation.CompletionResultType]::ParameterValue, $_.name); 
		}
	}

	Register-ArgumentCompleter -ParameterName "RepositoryId" -ScriptBlock {   
		Get-GitRepository | Sort -Property name | % { 
			New-Object -TypeName System.Management.Automation.CompletionResult -ArgumentList @($_.id, $_.name, [System.Management.Automation.CompletionResultType]::ParameterValue, $_.name); 
		}
	}
}