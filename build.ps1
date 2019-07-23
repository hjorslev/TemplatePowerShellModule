[CmdletBinding()]
Param ()

# Line break for readability in AppVeyor console
Write-Host -Object ''

Set-BuildEnvironment -ErrorAction SilentlyContinue

# Make sure we're using the Master branch and that it's not a pull request
# Environmental Variables Guide: https://www.appveyor.com/docs/environment-variables/
if ($env:APPVEYOR_REPO_BRANCH -ne 'master') {
    Write-Warning -Message "Skipping version increment and publish for branch $env:APPVEYOR_REPO_BRANCH"
} elseif ($env:APPVEYOR_PULL_REQUEST_NUMBER -gt 0) {
    Write-Warning -Message "Skipping version increment and publish for pull request #$env:APPVEYOR_PULL_REQUEST_NUMBER"
} else {
    # We're going to add 1 to the revision value since a new commit has been merged to Master
    # This means that the major / minor / build values will be consistent across GitHub and the Gallery
    try {
        # Start by importing the manifest to determine the version, then add 1 to the revision
        $Manifest = Test-ModuleManifest -Path $env:BHPSModuleManifest
        [System.Version]$Version = $Manifest.Version
        Write-Output -InputObject "Old Version: $Version"
        [String]$NewVersion = New-Object -TypeName System.Version -ArgumentList ($Version.Major, $Version.Minor, $env:APPVEYOR_BUILD_NUMBER)
        Write-Output -InputObject "New Version: $NewVersion"

        # Update the manifest with the new version value.
        $FunctionList = ((Get-ChildItem -Path ".\$($env:BHProjectName)\Public").BaseName)
        $Splat = @{
            'Path'              = $env:BHPSModuleManifest
            'ModuleVersion'     = $NewVersion
            'FunctionsToExport' = $FunctionList
            'Copyright'         = "(c) 2019-$( (Get-Date).Year ) $(Get-Metadata -Path $env:BHPSModuleManifest -PropertyName Author). All rights reserved."
        }

        Update-ModuleManifest @Splat

        # Update functions to export.
        Set-ModuleFunction

    } catch {
        throw $_
    }

    # Create new markdown and XML help files
    Write-Host -Object "Building new function documentation" -ForegroundColor Yellow
    if ((Test-Path -Path "$($env:BHProjectPath)\docs") -eq $false) {
        New-Item -Path $env:BHProjectPath -Name 'docs' -ItemType Directory
    }
    Import-Module -Name "$env:BHProjectPath\$($env:BHProjectName)" -Force
    New-MarkdownHelp -Module $($env:BHProjectName) -OutputFolder '.\md-docs\' -Force
    New-ExternalHelp -Path '.\docs\' -OutputPath ".\en-US\" -Force
    Copy-Item -Path '.\README.md' -Destination 'docs\index.md'
    Copy-Item -Path '.\CHANGELOG.md' -Destination 'docs\CHANGELOG.md'
    Copy-Item -Path '.\CONTRIBUTING.md' -Destination 'docs\CONTRIBUTING.md'

    # Build documentation
    mkdocs build
    Write-Host -Object 'Done building documentation..' -ForegroundColor Green
    Write-Host -Object ''

    # Publish the new version to the PowerShell Gallery
    try {
        # Build a splat containing the required details and make sure to Stop for errors which will trigger the catch
        $PM = @{
            Path        = ".\$($env:BHProjectName)"
            NuGetApiKey = $env:NuGetApiKey
            ErrorAction = 'Stop'
        }

        Publish-Module @PM
        Write-Host -Object "$($env:BHProjectName) PowerShell Module version $($NewVersion) published to the PowerShell Gallery." -ForegroundColor Cyan
    } catch {
        # Sad panda; it broke
        Write-Warning -Message "Publishing update $($NewVersion) to the PowerShell Gallery failed."
        throw $_
    }

    # Get latest changelog and publish it to GitHub Releases.
    $ChangeLog = Get-Content -Path '.\CHANGELOG.md'
    # Expect that the latest changelog info is located at line 8.
    $ChangeLog = $ChangeLog.Where( { $_ -eq $ChangeLog[7] }, 'SkipUntil')
    # Grab all text until next heading that starts with ## [.
    $ChangeLog = $ChangeLog.Where( { $_ -eq ($ChangeLog | Select-String -Pattern "## \[" | Select-Object -Skip 1 -First 1) }, 'Until')

    #TODO New-GitHubRelease -Owner $(Get-Metadata -Path $env:BHPSModuleManifest -PropertyName CompanyName) -RepositoryName $($env:BHProjectName) -TagName "v$($NewVersion)" -name "v$($NewVersion) Release of $($($env:BHProjectName))" -ReleaseNote $ChangeLog -Token ($env:GitHubKey)

    # Publish the new version back to Master on GitHub
    try {
        # Set up a path to the git.exe cmd, import posh-git to give us control over git, and then push changes to GitHub
        # Note that "update version" is included in the appveyor.yml file's "skip a build" regex to avoid a loop
        $env:Path += ";$env:ProgramFiles\Git\cmd"
        Import-Module posh-git -ErrorAction Stop
        git checkout master
        git add --all
        git status
        git commit -s -m "Update version to $($NewVersion)"
        git push origin master
        Write-Host -Object "$($env:BHProjectName) PowerShell Module version $($NewVersion) published to GitHub." -ForegroundColor Cyan
    } catch {
        # Sad panda; it broke
        Write-Warning "Publishing update $($NewVersion) to GitHub failed."
        throw $_
    }
}