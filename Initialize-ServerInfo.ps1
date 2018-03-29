function Initialize-ServerInfo {
    [CmdletBinding()]
	param([Parameter(Mandatory)]$serverUri,$defaultProjectId = $null)
	#Credentials 
    
	if (-Not (get-command Get-AzureAdAccessToken -ErrorAction SilentlyContinue)) { 
		${VSTS-Bearer} = Read-Host "Bearer token or leave empty to use DefaultCredentials"
    } else{
        Get-AzureAdAccessToken -VstsCollectionUri $serverUri -ResourceId 499b84ac-1321-427f-aa17-267ca6975798
    }
	
	$projectApiVersion = "api-version=1.0-preview"
    $projectBaseUri = "$serverUri/DefaultCollection/_apis/projects"
    $projects = "$($projectBaseUri)?$($projectApiVersion)"
	
	#Get Defaultproject 
	if (-NOT $defaultProjectId) {
		$projectsList = (Invoke-ApiRequest -Method Get -Uri $projects).value
		$defaultProjectId = $projectsList[$projectsList.length-1].id
	}	
	
	Set-Project -serverUri $serverUri -ProjectId $defaultProjectId
}