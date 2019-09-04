[CmdletBinding()]
Param ()

$Modules = @(
    'BuildHelpers',
    'Configuration',
    'Pester',
    'platyPS',
    'posh-git',
    'PSDepend',
    'PSDeploy',
    'psake',
    'PSScriptAnalyzer',
    'powershell-yaml'
)

foreach ($Module in $Modules) {
    Install-Module -Name $Module -Scope CurrentUser -Force -AllowClobber
    Write-Host -Object "Installing module $($Module)..."
}

# Global import is need for psake.
Import-Module -Name $Modules -Force -Global