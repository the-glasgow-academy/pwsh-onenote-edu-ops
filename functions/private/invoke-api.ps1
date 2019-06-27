function Invoke-Api {
    [CmdletBinding()]

    Param (
        [Parameter()]
        [string]
        $Version = "v1.0",
        
        [Parameter(Mandatory = $true)]
        [string]
        $Method,

        [Parameter(Mandatory = $true)]
        [string]
        $Endpoint
    )

    Process {
        $resource = "https://graph.microsoft.com/$Version"
        $request = @{
            method = "$method"
            contentType = "application/json"
            headers = @{"authorization" = "bearer $ENV:GRAPH_API_TOKEN"
            uri = ($resource + $endpoint)
        }
        if ($body) {$request["body"] = $body}
        Invoke-RestMethod @request
    }
}
