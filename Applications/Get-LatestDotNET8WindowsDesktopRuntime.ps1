#requires -RunAsAdministrator
$ProgressPreference = 'SilentlyContinue'
$ErrorActionPreference = 'SilentlyContinue'
Clear-Host
Write-Host "[ Get-LatestDotNET8WindowsDesktopRuntime.ps1 ]" -ForegroundColor Magenta
Write-Host "Installing latest .NET 8 Windows Desktop Runtime, please wait... "
winget install Microsoft.DotNet.DesktopRuntime.8 --force --silent
Write-Host "Done!" -ForegroundColor Green
