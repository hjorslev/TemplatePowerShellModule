#requires -Version 2
# Get public and private function definition files.
$Public = @( Get-ChildItem -Path $PSScriptRoot\Public\*.ps1 -Recurse -ErrorAction SilentlyContinue )
$Private = @( Get-ChildItem -Path $PSScriptRoot\Private\*.ps1 -Recurse -ErrorAction SilentlyContinue )

# Dot source the files
foreach ($Import in @($Public + $Private)) {
    try {
        . $Import.fullname
    } catch {
        Write-Error -Message "Failed to import function $($Import.fullname): $_"
    }
}

Export-ModuleMember -Function $Public.Basename