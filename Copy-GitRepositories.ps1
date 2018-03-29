function Copy-GitRepositories {
	[CmdletBinding()]
	param([Parameter(Mandatory)]$DestinationFolder)
	
	Push-Location $DestinationFolder
	Get-GitRepository | Select -ExpandProperty remoteUrl | % { 
		Start-Process git.exe -ArgumentList "clone", $_ -Wait
	}
	Pop-Location
}