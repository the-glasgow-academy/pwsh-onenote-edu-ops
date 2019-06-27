function Connect-Api {
    [CmdletBinding()]

    Param (
        [Parameter(Mandatory = $true)]
        [string]
        $ClientID,

        [Parameter(Mandatory = $true)]
        [string]
        $ClientSecret,

        [Parameter(Mandatory = $true)]
        [string]
        $TenantId
    )

    Process {
        $resource = "https://graph.microsoft.com/"
        $body = @{
            "grant_type"    = "client_credentials"
            "client_id"     = "$ClientId"
            "client_secret" = "$ClientSecret"
            "resource"      = "$resource"
        }
        $request = @{
            method      = "POST"
            URI         = "https://login.microsoftonline.com/$TenantId/ouath2/token"
            contentType = "application/x-www-form-urlencoded"
            body        = $body
        }
        $ENV:GRAPH_API_TOKEN = (Invoke-RestMethod @request).access_token
    }
}
    
