function Get-Notebook {
    [CmdletBinding()]

    Param (
        [Parameter(Mandatory = $true)]
        [ValidateSet('user','group','site']
        [String]
        $Scope,

        [Parameter(Mandatory = $true)]
        [String]
        $Id,

        # Will select a specific notebook if the ID is specified
        [Parameter()]
        [String]
        $NotebookId
    )

    Process {
        $ep = "/$scope/$id/onenote/notebooks"
        if ($NotebookId) {$ep = $ep + "/$NotebookId"}
        Invoke-Api -Method "GET" -Endpoint "/$Scope/$Id/onenote/notebooks"
    }
}

