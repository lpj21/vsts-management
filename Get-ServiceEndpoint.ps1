function Get-ServiceEndpoint {
	[CmdletBinding()]
    param($ServiceEndpointId)

    if ([string]::IsNullOrEmpty($ServiceEndpointId))
    {
        $endpoints = Invoke-ApiRequest -Method Get -Uri $VSTS.Endpoints  
        $endpointsIds = $endpoints.value | Select -ExpandProperty id
    }
    else
    {
        $endpointsIds = @($ServiceEndpointId)
    }

    $endpointsIds | % {
        $cEndPointId = $_
        $endpoint = Invoke-ApiRequest -Method Get -Uri ($VSTS.Endpoint -f $cEndPointId)  
        $endpoint
    }    
}