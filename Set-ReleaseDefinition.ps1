function Set-ReleaseDefinition {
    param($ReleaseDefinition)
      
    Invoke-ApiRequest -Method Put -Uri ($VSTS.ReleaseDefinition -f $ReleaseDefinition.id) -Body ($ReleaseDefinition | ConvertTo-Json -Depth 100 -Compress)
}