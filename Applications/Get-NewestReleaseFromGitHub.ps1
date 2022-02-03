<#
    - [Name] Get-NewestReleaseFromGitHub.ps1
    - [Description] Uses the GitHub API to pull the latest release of any app, tool or utility hosted on GitHUb.
    - [Author] John Gage Faulkner
    - [Last Updated] 02/03/2022
    - [Resources and References]
        - Build the download URL: "https://github.com/$repo/releases/download/$tag/$file"
        - Download URL Example: https://github.com/microsoft/winget-cli/releases/download/v1.2.10271/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle
        - Install an .AppX Package: Add-AppxPackage -Path $output
    - # Get-Date -DisplayHint Time
#>
Clear-Host
Write-Host "[ Get-NewestReleaseFromGitHub.ps1 ]"

# Define Environment Variables
$ProgressPreference = 'SilentlyContinue'
$ErrorActionPreference = 'SilentlyContinue'
$targetExtensions = @(".msixbundle", ".msix", ".msi", ".exe", ".appxbundle", ".appx")

# Step 1: Ask for user input
$repo = Read-Host -Prompt "Please Enter the GitHub Repo Name (e.g. microsoft/winget-cli)"
$GitHubReleasesURL = "https://api.github.com/repos/$repo/releases" # The URL to the GitHub API for Releases.
Write-Host "Targeted Repo: " -NoNewline
Write-Host "$GitHubReleasesURL" -ForegroundColor Green

# Step 2: Get the latest release from GitHub
Write-Host "Getting the latest release from GitHub, please wait..."
Write-Host

try {
    $json = Invoke-WebRequest $GitHubReleasesURL -Method Get -ContentType "application/json" -Headers @{Accept = "application/vnd.github.v3+json" } # Send a 'GET' request to the GitHub REST API (returns JSON.)    
    $releaseObj = ($json | ConvertFrom-Json)[0] # Convert the JSON to a PowerShell object.
    $releaseId = $releaseObj.id # Get the ID of the latest release.
    $releaseName = $releaseObj.tag_name # Get the name of the latest release.
    Write-Host "Latest Release: $releaseName"

    Write-Host "Retrieving list of assets from this release... "
    $apiUrlForRelease = "https://api.github.com/repos/$repo/releases/$releaseId/assets" # The URL to the GitHub API for the latest release.
    $releaseAssetList = Invoke-RestMethod -Method Get -Uri $apiUrlForRelease -ContentType "application/json" -Headers @{Accept = "application/vnd.github.v3+json" }

    Write-Host "Finding download links for your Operating System, please wait... "
    foreach ($myAsset in $releaseAssetList) {
        $assetId = $myAsset.id
        $assetName = $myAsset.name # Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle
        $assetAPIUrl = "https://api.github.com/repos/$repo/releases/assets/$assetId"
        $assetSizeMB = [math]::round($myAsset.size / 1MB, 2)
        $assetDownloadUrl = $myAsset.browser_download_url

        if (($targetExtensions | ForEach-Object { $assetName.contains($_) }) -contains $true) {
            Write-Host "Targeted Asset: " -NoNewline
            Write-Host "$assetName ($assetSizeMB MB)" -ForegroundColor Green
            $assetFileOutput = $env:APPDATA + "\$assetName"
            Write-Host "[Asset Download URL] $assetDownloadUrl"
            Write-Host "[Asset Local File Name] $assetFileOutput"
            Write-Host "Downloading, please wait... " -NoNewline
            Invoke-WebRequest -Uri $assetDownloadUrl -OutFile $assetFileOutput
            Write-Host "Done!" -ForegroundColor Green
            break
        }
    }

    Write-Host
    Write-Host "Installing the package, please wait... "
    
}

catch {
    Write-Host "An error occurred while trying to get the latest release from GitHub." -ForegroundColor Red
    $issueStr = "$($PSItem.ToString())"
    Write-Warning -Message $issueStr
    Write-Host
}

<# 
    Examples

- [Write a Full Error Message]
Write-Error -Message $PSItem.Exception.Message -RecommendedAction "Please try entering the repo name again." -ErrorAction Stop

- [Full HTTP API Request Example]
$apiResponseAsJson = Invoke-WebRequest $GitHubReleasesURL -UseBasicParsing -OutFile $null -NoProxy -Uri $null -Method Get -ContentType "application/json" -Headers @{Accept="application/json"}

#>