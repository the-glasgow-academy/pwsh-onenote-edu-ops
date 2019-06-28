function Invoke-Api {
    [CmdletBinding()]

    Param (
        [Parameter()]
        [string]
        $Version = "v1.0",
        
        [Parameter(Mandatory = $true)]
        [string]
        $Method,

        [Parameter()]
        [string]
        $Endpoint,

        [Parameter()]
        [string]
        $Uri,

        [Parameter()]
        [string]
        $Body
    )

    Process {
        $resource = "https://graph.microsoft.com/$Version"
        if ($Endpoint) { $uri = $resource + $Endpoint}
        $request = @{
            method      = "$method"
            contentType = "application/json"
            headers     = @{ "authorization" = "bearer $ENV:GRAPH_API_TOKEN" }
            uri         = $uri
        }
        if ($body) { $request["body"] = $body }
        Invoke-RestMethod @request
    }
}
