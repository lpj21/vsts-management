function Get-Project {
	[CmdletBinding()]
    param($ProjectId)

    if ([string]::IsNullOrEmpty($ProjectId))
    {
        $projects = Invoke-ApiRequest -Method Get -Uri $VSTS.Projects
        $projectsIds = $projects.value | Select -ExpandProperty id
    }
    else
    {
        $projectsIds = @($ProjectId)
    }

    $projectsIds | % {
        $cProjectId = $_
        $project = Invoke-ApiRequest -Method Get -Uri ($VSTS.Project -f $cProjectId) 
        $project
    }    
}