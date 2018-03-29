function Get-GitRef {
    [CmdletBinding(DefaultParameterSetName="Default")]
    param(
    [Parameter(Mandatory=$true, ParameterSetName="JustBranches")]
    [Parameter(Mandatory=$true, ParameterSetName="JustTags")]
    [Parameter(Mandatory=$true, ParameterSetName="Default")]
    $RepositoryId,
    [Parameter(ParameterSetName="JustBranches")]
    [Switch]$BranchesOnly,
    [Parameter(ParameterSetName="JustTags")][Switch]$TagsOnly)

    switch($PSCmdlet.ParameterSetName){
        "Default" { $uri =  $($VSTS.GitRefs -f $RepositoryId) }
        "JustBranches" { $uri = $($VSTS.GitRef -f $RepositoryId,"heads") }
        "JustTags" { $uri = $($VSTS.GitRef -f $RepositoryId,"tags") }
    }

    $refs = Invoke-ApiRequest -Method Get -Uri $uri
    $refs.value
}
