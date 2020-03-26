<#
.SYNOPSIS
Imports an SCModule into the current session

.DESCRIPTION
Imports the PowerShell module portion of an SCModule into the current session

.PARAMETER SCModule
The SCModule to imported

.PARAMETER Passthru
Specify whether to pass SCModule down the pipeline

.EXAMPLE
Get-SCModule .\SC_Module | Import-SCModule

.NOTES
Author: Scott Crawford
#>

function Import-SCModule {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [SCModuleInfo]$SCModule
        ,
        [switch]$Passthru = $false
    )

    process {
        try {
            $SCModule.Import()

            if ($Passthru) {
                Write-Output $SCModule
            }
        } catch {
            Write-Error $Error[0]
        }
    }
}
