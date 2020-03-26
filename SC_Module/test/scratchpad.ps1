<#
This is needed during development of SC_Module. Since it's own functions may be
modified, this copies the current state elsewhere and imports that version,
leaving you free to modify the "real" version. Powershell should be reset and
these command run after every modification. Especially to the class file.
#>
Set-Location C:\Users\scott\OneDrive\Source\Repos\Systems.PowerShell\Modules
robocopy .\SC_Module\SC_Module C:\Save\SC_Module /mir
Import-Module C:\Save\SC_Module -Force
$mod = Get-SCModule SC_Module
[SCModuleInfo]::New('SC_Module', '.\SC_Module')

$mod | Update-SCModule -Verbose
$mod.Commit()
$mod.PopulateExportedMembers()
$mod.PopulateModule()
$mod.Update()
$mod | Update-SCModule -Verbose
Update-SCModule $mod
$mod.Module.Version

<# The rest of this is just random testing stuff.
$mod.GetStep()

$mod = Get-SCModule .\SC_ComputerLifecycle
#$mods = 'a'
#$mods = dir |  Get-SCModule #-Verbose
$mods | Get-SCModuleFingerprint
$mods | Get-SCModuleExportedMembers
#$mod.Module|select *

# Update the manifest for all changed modules
$exportedMembers = Get-SCModuleExportedMembers -Module $mod.Module
Update-ModuleManifest @exportedMembers -Path $mod.Module.Path

$mod.Module.ExportedCommands

$mod = Get-SCModule .\SC_ComputerLifecycle
Get-SCModuleBumpVersionType -SCModule $mod -Verbose |
    Step-SCModule $mod
#>

        $newManifest = Import-PowerShellDataFile -Path .\SC_Module\SC_Module\SC_Module.psd1
        $keysToRemove = @()
        foreach ($key in $newManifest.Keys) {
            if ($newManifest.Item($key).Count -eq 0) {$keysToRemove += $key}
        }
        foreach ($key in $keysToRemove) {$newManifest.Remove($key)}

        #Update-ModuleManifest -Path $this.ManifestPath @newManifest
        return $keysToRemove


        $mod = Nenw-SCModule TestMod
        $oldName = "$($mod.ModulePath)\old.psd1"
        Rename-Item $mod.ManifestPath $oldName
        $filecontent = Get-Content -Path $oldName
        $newcontent = $filecontent.Replace("'*'", "@()")
        Set-Content -Path $mod.ManifestPath -Value $newcontent
        fc.exe $oldName $mod.ManifestPath