#requires -RunAsAdministrator
$ProgressPreference = 'SilentlyContinue'
$ErrorActionPreference = 'SilentlyContinue'
Clear-Host
Write-Host "[ Get-LatestWinAppSDK.ps1 ]" -ForegroundColor Magenta

# Define Variables
$WinAppSDKDownloadUrl = "https://aka.ms/windowsappsdk/1.4/1.4.231115000/windowsappruntimeinstall-x64.exe"

# Init
Write-Host "Downloading Windows App SDK v1.4.231115000 Runtime, please wait... " -NoNewLine
Invoke-WebRequest -Uri $WinAppSDKDownloadUrl -OutFile windowsappruntimeinstall-x64.exe
Write-Host "Done!" -ForegroundColor Green

Write-Host "Installing Windows App SDK v1.4.231115000 Runtime, please wait... " -NoNewLine
Start-Process -FilePath "windowsappruntimeinstall-x64.exe" -ArgumentList "--force","--quiet" -Wait
Write-Host "Done!" -ForegroundColor Green

Write-Host "Operation completed successfully!"
