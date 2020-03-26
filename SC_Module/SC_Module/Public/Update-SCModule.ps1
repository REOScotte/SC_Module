<#
.SYNOPSIS
Updates version and export information for an SC Module

.DESCRIPTION
Uses the .Update() method of SCModule to update version and export information in the manifest.
Sometimes the manifest file is locked while editing, so this will retry up to 10 times.

.PARAMETER SCModule
The SCModule to updated

.PARAMETER UserGroup
Specifies the UserGroup property of an SCModule so Publish-SCModule.ps1 knows which group to give permissions to.

This value is stored in UserGroup.txt in the root of the SCModule.

.PARAMETER Step
A step type to increment the version of the SCModule

.PARAMETER RetryCount
A counter to eventually fail out of repeated calls to the command during errors.

.PARAMETER Passthru
Specify whether to pass SCModule down the pipeline

.EXAMPLE
Get-SCModule .\SC_Module | Update-SCModule

.NOTES
Author: Scott Crawford
#>

function Update-SCModule {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [SCModuleInfo]$SCModule
        ,
        [UserGroup]$UserGroup
        ,
        [VersionStep]$Step
        ,
        [switch]$Passthru = $false
        ,
        [int]$RetryCount = 1
    )

    process {
        try {
            # Only update version or user group if they're specified.
            if ($PSBoundParameters.ContainsKey('UserGroup')) {$SCModule.UserGroup = $UserGroup}
            if ($PSBoundParameters.ContainsKey('Step')) {$SCModule.UpdateVersion([VersionStep]$Step)}

            Write-Verbose "This is attempt number $RetryCount"
            $SCModule.Update()

            if ($Passthru) {
                Write-Output $SCModule
            }

        } catch {
            if ($RetryCount -lt 10) {
                Start-Sleep -Seconds 1
                $RetryCount++
                # Remove the bound copy of RetryCount so we can pass the incremented version
                if ($PSBoundParameters.ContainsKey('RetryCount')) {$PSBoundParameters.Remove('RetryCount')}
                Update-SCModule @PSBoundParameters -RetryCount $RetryCount
            } else {
                Write-Verbose "Failing after $RetryCount tries."
                Write-Error $Error[0]
            }
        }
    }
}
