function New-Content { 
    [CmdletBinding()]

    Param (
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]
        $self,

        [Parameter()]
        [ValidateSet('sections', 'sectionGroups')]
        [string]
        $ContentType,

        [Parameter(Mandatory = $true)]
        [string]
        $DisplayName
    )

    Process {
        $ep = $self + "/$ContentType"
        $body = @{ "displayName" = "$DisplayName" } | convertto-json
        Invoke-Api -Method "POST" -uri $ep -body $body
    }
}
    
