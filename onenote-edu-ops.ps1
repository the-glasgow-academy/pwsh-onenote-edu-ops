function Connect-Api {

    [CmdletBinding()]

    Param (
        [Parameter(Mandatory = $true)]
        [string]
        $ClientId,

        [Parameter(Mandatory = $true)]
        [string]
        $ClientSecret,

        [Parameter(Mandatory = $true)]
        [string]
        $TenantId
    )

    Begin {
        $resource = "https://www.onenote.com"
    }

    process {
        $B = @{
            "grant_type"    = "client_credentials"
            "client_id"     = "$ClientId"
            "client_secret" = "$ClientSecret"
            "resource"      = "$resource"
        }
        $R = @{
            method      = "POST"
            URI         = "https://login.microsoftonline.com/$TenantId/oauth2/token"
            contentType = "application/x-www-form-urlencoded"
            body        = $B
        }
        $ENV:ONENOTE_API_TOKEN = (Invoke-RestMethod @R).access_token
    }
}

function Get-Data {

    [CmdletBinding()]

    Param (
        [Parameter()]
        [string]
        $Version = "v1.0",

        [Parameter(Mandatory = $true)]
        [string]
        $Endpoint,

        [Parameter()]
        [switch]
        $IsTeams
    )

    Begin {
        if (!$ENV:ONENOTE_API_TOKEN) { Write-Error -Message 'No API Token found, please use Connect-API' }
        $resource = "https://www.onenote.com/api/$version"
    }

    Process {
        $R = @{
            method      = "GET"
            contentType = "application/json"
            headers     = @{
                "authorization" = "Bearer $ENV:ONENOTE_API_TOKEN"
            }
            uri         = ($resource + $endpoint)
        }
        if ($IsTeams) {
            $g.headers.Add("CustomUserAgent", "Teams/1.0")
            Invoke-RestMethod @R
        }
    }
}
    
function Get-Notebooks {

    [CmdletBinding()]

    Param (
        [Parameter()]
        [string]
        $UPN
    )

    Process {
        Get-Data -Endpoint "/users/$UPN/notes/notebooks"
    }
}

function Get-TeamNotebook {

    [CmdletBinding()]

    Param ( 
        [Parameter(Mandatory = $true)]
        [string]
        $TeamID
    )

    Process {
        Get-Data -Endpoint "/notes/classnotebooks/myOrganization/groups/$TeamID" -IsTeams
    }
}

function Add-Data {
    [CmdletBinding()]

    Param (
        [Parameter()]
        [string]
        $Version = "v1.0",

        [Parameter(Mandatory = $true)]
        [hashtable]
        $Body,

        [Parameter(Mandatory = $true)]
        [string]
        $Endpoint,

        [Parameter()]
        [switch]
        $IsTeams
    )
    
    begin {
        $resource = "https://www.onenote.com/api/$version"
    }

    process {
        $B = $body | ConvertTo-Json
        $R = @{
            method      = "POST"
            contentType = "application/json"
            body        = $B
            headers     = @{
                "authorization" = "bearer $ENV:ONENOTE_API_TOKEN"
            }
            uri         = ($resource + $endpoint)
        }
        if ($IsTeams) {
            $R.headers.Add("CustomUserAgent", "Teams/1.0")
            Invoke-RestMethod @R 
        }
    }
}

function New-TeamClassNotebook { 
    [CmdletBinding()]

    Param (
        [Parameter(Mandatory = $true)]
        [string]
        $TeamId,

        [Parameter(Mandatory = $true)]
        [string]
        $NotebookName,

        [Parameter()]
        [switch]
        $TeacherOnlySection,

        [Parameter(Mandatory = $true)]
        [string[]]
        $NotebookSections
    )

    process {
        $B = @{
            "name"            = "$NotebookName"
            "studentSections" = $NotebookSections
        }
        if ($TeacherOnlySection) { $B.Add("hasTeacherOnlySectionGroup", "true") }
        Add-Data -Endpoint "/notes/classnotebooks/myOrganization/groups/$TeamId" -body $B -IsTeams
    } 
}

function Set-Data {
    [CmdletBinding()]

    Param (
        [Parameter()]
        [string]
        $Version = "v1.0",

        [Parameter(Mandatory = $true)]
        [hashtable]
        $Body,

        [Parameter(Manadatory = $true)]
        [string]
        $Endpoint,

        [Parameter()]
        [switch]
        $IsTeams
    )

    begin {
        $resource = "https://www.onenote.com/api/$version"
    }

    process {
        $B = $Body | ConvertTo-Json
        $R = @{
            method      = "PATCH"
            contentType = "application/json"
            body        = $B
            headers     = @{
                "authorization" = "bearer $ENV:ONENOTE_API_TOKEN"
            }
            uri         = ($resource + $Endpoint)
        }
        if ($IsTeams) {
            $R.headers.Add("CustomUserAgent", "Teams/1.0")
            Invoke-RestMethod @R 
        }
    }
}

function Add-TeacherOnlySection {
    [CmdletBinding()]

    Param (
        [Parameter(Mandatory = $true)]
        [string]
        $TeamId,

        [Parameter(Mandatory = $true)]
        [string]
        $NotebookId
    )
        
    process {
        $b = @{"hasTeacherOnlySectionGroup" = "true" }
        Set-Data -Endpoint "/notes/classnotebooks/myOrganization/groups/$TeamId/$NotebookId" -Body $b -IsTeams
    }
}

function Copy-Section {
    [CmdletBinding()]

    Param (
        [Parameter(Mandatory = $true)]
        [string]
        $DestinationTeamId,

        [Parameter(Mandatory = $true)]
        [string]
        $DestinationSectionId,

        [Parameter(Mandatory = $true)]
        [string]
        $SourceSectionId,
        
        [Parameter(Mandatory = $true)]
        [string]
        $SourceUPN
    )

    process {
        $B = @{
            id      = "$DestinationSectionId"
            groupId = "$DestinationTeamId"
        }
        Add-Data -Body $B -Endpoint "/users/$SourceUPN/onenote/sections/$SourceSectionId/copyToSectionGroup"
    }
}


