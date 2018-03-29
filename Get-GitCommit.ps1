function Get-GitCommit {
    [CmdletBinding(DefaultParameterSetName="Default")]
    param([Parameter(Mandatory)]$RepositoryId,
          [Parameter(Mandatory,ParameterSetName="SourceBranch")]$SourceBranch, 
          $Top)

    $top = '$top=' + $Top
    switch($PSCmdlet.ParameterSetName)
    {
        "SourceBranch" { 
            $commits = Invoke-ApiRequest -Method Get -Uri "$($VSTS.GitCommitsBranch -f $RepositoryId,$SourceBranch)&$top"  
            $commits = $commits.value
            $commits
        }
         "Default" { 
            $commits = Invoke-ApiRequest -Method Get -Uri "$($VSTS.GitCommits -f $RepositoryId)&$top"  
            $commits = $commits.value
            $commits
         }
    }
}

