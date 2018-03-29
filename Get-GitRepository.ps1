function Get-GitRepository {
    [CmdletBinding()]
    param($RepositoryId)

    if ([string]::IsNullOrEmpty($RepositoryId))
    {
        $repositories = Invoke-ApiRequest -Method Get -Uri $VSTS.GitRepositories  
        $repositories = $repositories.value
        $repositories
    }
    else
    {
        $repository = Invoke-ApiRequest -Method Get -Uri ($VSTS.GitRepository -f $RepositoryId)  
        $repository
    }
}
