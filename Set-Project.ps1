function Set-Project {
	param($serverUri, $ProjectId)
	
	$defaultProjectId = $ProjectId
   
	# Project REST api
	$projectApiVersion = "api-version=1.0-preview"
	$projectBaseUri = "$serverUri/DefaultCollection/_apis/projects"
	$projects = "$($projectBaseUri)?$($projectApiVersion)"
	$project = "$projectBaseUri/{0}?$projectApiVersion"
		
	$baseUri = "$serverUri/DefaultCollection/$defaultProjectId/_apis"
	
	# Release REST api
	$releaseApiVersion = "api-version=2.3-preview.1"
	$releaseBaseUri = "$baseUri/release"
	$releaseDefinitions = "$releaseBaseUri/definitions?$releaseApiVersion"
	$releaseDefinition = "$releaseBaseUri/definitions/{0}?$releaseApiVersion"
	$releases = "$releaseBaseUri/releases?$releaseApiVersion"
	$release = "$releaseBaseUri/releases/{0}?$releaseApiVersion"

	# Build REST api
	$buildApiVersion = "api-version=2.0-preview"
	$buildBaseUri = "$baseUri/build"
	$buildDefinitions = "$buildBaseUri/definitions?$buildApiVersion&type=build"
	$buildDefinition = "$buildBaseUri/definitions/{0}?$buildApiVersion"
	$builds = "$buildBaseUri/builds?$buildApiVersion&type=build"
	$build = "$buildBaseUri/builds/{0}?$buildApiVersion"

    # Git REST api
	$gitApiVersion = "api-version=1.0"
	$gitBaseUri = "$baseUri/git"
	$gitRepositories = "$gitBaseUri/repositories?$gitApiVersion"
	$gitRepository = "$gitBaseUri/repositories/{0}?$gitApiVersion"
	$gitCommits = "$gitBaseUri/repositories/{0}/commits?$gitApiVersion"
	$gitCommitsBranch = "$gitBaseUri/repositories/{0}/commits?$gitApiVersion&branch={1}"
	$gitCommit = "$gitBaseUri/repositories/{0}/commits?$gitApiVersion&commit={1}"
	$gitRefs = "$gitBaseUri/repositories/{0}/refs?$gitApiVersion"
	$gitRef = "$gitBaseUri/repositories/{0}/refs/{1}?$gitApiVersion"

	# Service Endpoint REST api
	$endpointsApiVersion = "api-version=2.0-preview"
	$endpointsBaseUri = "$baseUri/distributedtask"
	$endpoints = "$endpointsBaseUri/serviceendpoints?$endpointsApiVersion"
	$endpoint  = "$endpointsBaseUri/serviceendpoints/{0}?$endpointsApiVersion"
	
	$Global:VSTS = @{ 
		ReleaseDefinitions = $releaseDefinitions; 
		ReleaseDefinition = $releaseDefinition; 
		Releases = $releases; 
		Release = $release; 
		BuildDefinitions = $buildDefinitions; 
		BuildDefinition = $buildDefinition; 
		Builds = $builds; 
		Build = $build; 
		GitRepositories = $gitRepositories;
		GitRepository = $gitRepository
		GitRefs = $gitRefs;
		GitRef = $gitRef;
		GitCommits = $gitCommits;
		GitCommitsBranch = $gitCommitsBranch;
		GitCommit = $gitCommit;
		Projects = $projects; 
		Project = $project; 
		Endpoints = $endpoints; 
		Endpoint = $endpoint; 
		DefaultProjectId = $defaultProjectId 
	}
   
}