function Copy-Section {
    [CmdletBinding()]

    Param (
        # ID of a notebook or a section group
        [Parameter(Mandatory = $true)]
        [String]
        $DestinationId,
        
        # If copying to a group set the groups id
        [Parameter()]
        [String]
        $DestinationGroupId,

        # ID of section to copy
        [Parameter(Mandatory = $true)]
        [string]
        $SourceSectionId,

        # ID of user or group to copy from
        [Parameter(Mandatory = $true)]
        [string]
        $SourceId,

        # Define if user or group
        [Parameter(Mandatory = $true)]
        [ValidateSet('users', 'groups')]
        [string]
        $SourceScope,

        [Parameter()]
        [string]
        $NewName
    )

    Process {
        $b = @{id = "$DestinationId" }
        if ($DestinationGroupId) { $b["groupId"] = "$DestinationGroupId" }
        if ($NewName) { $b["renameAs"] = "$NewName" }
        Invoke-Api -Method "POST" -Endpoint "/$SourceScope/$SourceId/sections/$SourceSectionId/CopyToNotebook"
    }
}
        
