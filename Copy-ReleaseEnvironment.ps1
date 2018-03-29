function Copy-ReleaseEnvironment { 
    [CmdletBinding()]
    param($ReleaseDefinitionId,$NewEnvironmentName)
    DynamicParam {
        $environmentNameParam = 'EnvironmentName'
           
        $RuntimeParameterDictionary = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary
        $AttributeCollection = New-Object System.Collections.ObjectModel.Collection[System.Attribute]
            
        $ParameterAttribute = New-Object System.Management.Automation.ParameterAttribute
        $ParameterAttribute.Mandatory = $true
        $AttributeCollection.Add($ParameterAttribute)
            
        if ($ReleaseDefinitionId) {         
            $arrSet = Get-ReleaseDefinition -ReleaseDefinitionId $ReleaseDefinitionId | Select -ExpandProperty environments | Select -Expand name
            $ValidateSetAttribute = New-Object System.Management.Automation.ValidateSetAttribute($arrSet)

            $AttributeCollection.Add($ValidateSetAttribute) 
        } 

        $RuntimeParameter = New-Object System.Management.Automation.RuntimeDefinedParameter($environmentNameParam, "System.Collections.Generic.List[string]", $AttributeCollection)
        $RuntimeParameterDictionary.Add($environmentNameParam, $RuntimeParameter)
        return $RuntimeParameterDictionary

    }
    process {
        $release = Get-ReleaseDefinition -ReleaseDefinitionId $ReleaseDefinitionId

        # cloning the environment
        $environmentName = $MyInvocation.BoundParameters[$environmentNameParam]
        $newEnvironment = ($release.environments | ? { $_.name -eq $environmentName}).PsObject.Copy()
        $newEnvironment.id = 0
        $newEnvironment.name = $newEnvironmentName
        $newEnvironment.deployStep.id = 0
        $newEnvironment.preDeployApprovals.approvals | % { $_.id = 0 }
        $newEnvironment.postDeployApprovals.approvals | % { $_.id = 0 }

        $newEnvironment
    }
}
