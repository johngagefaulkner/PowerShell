#************ MANAGEENGINE ENDPOINTCENTRAL AGENT INSTALLATION ************
$ProgressPreference = 'SilentlyContinue'
$ErrorActionPreference = 'Stop'
Clear-Host
Write-Host "Installing ManageEngine's EndpointCentral Desktop Agent, please wait... "

## Define Variables
$DownloadUrl = "https://simplifymsp.b-cdn.net/SPPetroluem_Agent.exe"
$DownloadFolderPath = "C:\"
$DownloadFileName = "ManageEngineEndpointCentralAgent_Setup.exe"
$DownloadFullPath = "C:\ManageEngineEndpointCentralAgent_Setup.exe"

if (-not(Test-Path $DownloadFullPath)) {
    Write-Host "Downloading agent, please wait... "
  	(New-Object System.Net.WebClient).DownloadFile($DownloadUrl, $DownloadFullPath)
    Write-Host "Done!"
}

Set-Location -Path $DownloadFolderPath
[string]$InstallCmd = "$DownloadFileName /silent"
Write-Host "[Install Command] $InstallCmd"
Write-Host "Running install command, please wait... "

cmd /c $InstallCmd

Write-Host "Installation complete!"
