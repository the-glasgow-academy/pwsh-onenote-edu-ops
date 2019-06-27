function Get-Content {
    [CmdletBinding()]

    Param (
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]
        $self,

        [Parameter()]
        [ValidateSet('sections', 'sectionGroups', 'pages')]
        [string]
        $ContentType
    )

    Process {
        $ep = $self + "/$ContentType"
        Invoke-Api -Method "GET" -uri $ep
    }
}

