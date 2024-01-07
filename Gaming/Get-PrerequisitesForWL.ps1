#requires -RunAsAdministrator
$ProgressPreference = 'SilentlyContinue'
$ErrorActionPreference = 'SilentlyContinue'

# Init
Clear-Host
Write-Host "[ Install-PrerequisitesForWaferLauncher.ps1 ]" -ForegroundColor Magenta

# Define Variables
$InstallWinGetScriptUrl = "https://raw.githubusercontent.com/johngagefaulkner/PowerShell/main/Applications/Get-LatestWingetRelease.ps1"
$InstallDotNET8ScriptUrl = "https://raw.githubusercontent.com/johngagefaulkner/PowerShell/main/Applications/Get-LatestDotNET8WindowsDesktopRuntime.ps1"
$InstallWinAppSDKScriptUrl = "https://raw.githubusercontent.com/johngagefaulkner/PowerShell/main/Applications/Get-LatestWinAppSDK.ps1"

# Init
Write-Host "[ Step 1 ]" -ForegroundColor Cyan
Write-Host "Temporarily setting Execution Policy to Bypass... " -NoNewline
Set-ExecutionPolicy -ExecutionPolicy Bypass -Force
Write-Host "Done!" -ForegroundColor Green

Write-Host
Write-Host "[ Step 2 ]" -ForegroundColor Cyan

Write-Host "Installing winget, please wait... "
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString("$InstallWinGetScriptUrl"))
Write-Host "Done!" -ForegroundColor Green

Write-Host
Write-Host "[ Step 3 ]" -ForegroundColor Cyan

Write-Host "Installing .NET 8, please wait... "
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString("$InstallDotNET8ScriptUrl"))
Write-Host "Done!" -ForegroundColor Green

Write-Host
Write-Host "[ Step 4 ]" -ForegroundColor Cyan

Write-Host "Installing Windows App SDK, please wait... "
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString("$InstallWinAppSDKScriptUrl"))
Write-Host "Done!" -ForegroundColor Green

Clear-Host
Write-Host "Installing prerequisites for Wafer Launcher, please wait... " -NoNewLine
Write-Host "Done!" -ForegroundColor Green
Write-Host "Operation completed successfully!"
