<#
.SYNOPSIS
Removes an SCModule from the current session

.DESCRIPTION
Removes the PowerShell module portion of an SCModule from the current session

.PARAMETER SCModule
The SCModule to removed

.PARAMETER Passthru
Specify whether to pass SCModule down the pipeline

.EXAMPLE
Get-SCModule .\SC_Module | Remove-SCModule

.NOTES
Author: Scott Crawford
#>

function Remove-SCModule {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [SCModuleInfo]$SCModule
        ,
        [switch]$Passthru = $false
    )

    process {
        try {
            $SCModule.Remove()

            if ($Passthru) {
                Write-Output $SCModule
            }

        } catch {
            Write-Error $Error[0]
        }
    }
}
