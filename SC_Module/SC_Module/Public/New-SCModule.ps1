<#
.SYNOPSIS
Creates a blank module for Scotte

.DESCRIPTION
Creates a module template with place holders for functions and test.

.PARAMETER Name
Name of the new module

.PARAMETER Author
Author of the new module

.PARAMETER CompanyName
Company that created the module

.PARAMETER ModuleVersion
Desired base module version

.PARAMETER Description
Describes the module

.PARAMETER PowerShellVersion
Requred PowerShell version

.EXAMPLE
New-SCModule -Name NewModule

.NOTES
Author: Scott Crawford
#>

function New-SCModule {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [string]$Name,
        [string]$Description = "Scotte $Name Module",
        [string]$Author = 'Scott Crawford',
        [string]$CompanyName = 'scottes.com',
        [string]$PowerShellVersion = '5.1',
        [string]$ModuleVersion = (Get-Date -Format '0.0.0.yyyyMMdd'),
        [string]$TemplatePath = "$PSScriptRoot\..\Plaster\ScotteDefaultModule"
    )

    process {
        try {
            # Ensure Name starts with capitalized SC_. The length check prevents an error if there's less than 3 characters in the name
            if ($Name.Length -lt 3 -or $Name.Substring(0, 3) -ne 'SC_') {$Name = "SC_$Name"}
            $Name = $Name -replace "^...", "SC_"

            # Capture any output from Invoke-Plaster and redirect it to stream 6 so it doesn't interfere with the desired output.
            $informationStream = Invoke-Plaster -TemplatePath $TemplatePath -DestinationPath .\$Name -Name $Name -Description $Description -Author $Author -CompanyName $CompanyName -PowerShellVersion $PowerShellVersion -ModuleVersion $ModuleVersion
            Write-Information $informationStream

            # New manifests are created using '*' for various properties. These are replaced with the best practice of using @()
            $newManifestPath = ".\$Name\$Name\$Name.psd1"
            $manifestContent = Get-Content -Path $newManifestPath
            $updatedManifest = $manifestContent.Replace("'*'", "@()")
            Set-Content -Path $newManifestPath -Value $updatedManifest

            $euModule = Get-SCModule -Path .\$Name

            Write-Output $euModule
        } catch {
            Write-Error $Error[0]
        }
    }
}