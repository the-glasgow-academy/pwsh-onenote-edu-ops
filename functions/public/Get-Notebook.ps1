function Get-Notebook {
    [CmdletBinding()]

    Param (
        [Parameter(Mandatory = $true)]
        [ValidateSet('users', 'groups', 'sites')]
            [String]
            $Scope,

            [Parameter(Mandatory = $true)]
            [String]
            $Id,

            # Will select a specific notebook if the ID is specified
            [Parameter()]
            [String]
            $NotebookId,

            [Parameter()]
            [ValidateSet('notebooks', 'sections', 'sectionGroups', 'pages')]
            [String]
            $ContentType = 'notebooks'
        )

        Process {
            $ep = "/$scope/$id/onenote/notebooks"
            if ($NotebookId) { $ep = $ep + "/$NotebookId" }
            Invoke-Api -Method "GET" -Endpoint "/$Scope/$Id/onenote/$ContentType"
        }
    }

