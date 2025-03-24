#************ MANAGEENGINE ENDPOINTCENTRAL AGENT INSTALLATION ************
$ProgressPreference = 'SilentlyContinue'
$ErrorActionPreference = 'Stop'
Clear-Host
Write-Host "Installing ManageEngine's EndpointCentral Desktop Agent, please wait... "

## Define Variables
$DownloadUrl = "https://desktopcentral.manageengine.com/download?encapiKey=wSsVR61%2F%2FRX4Dap8zzKkdus5zA4HDlOiE05%2F0Fqm7nX4SvuQ8Mc8lE2dAlOiFfgdRWU6F2Ea8bJ4nE0DgWYGi4h8yg0FDCiF9mqRe1U4J3x18O7rwjKeWzs%3D"
$DownloadFolderPath = "C:\"
$DownloadFileName = "ManageEngineEndpointCentralAgent_Setup.exe"
$DownloadFullPath = "C:\ManageEngineEndpointCentralAgent_Setup.exe"

if (-not(Test-Path $DownloadFullPath)) {
	Write-Host "Downloading agent, please wait... "
  	(New-Object System.Net.WebClient).DownloadFile($DownloadUrl, $DownloadFullPath)
	Write-Host "Done!"
}

Set-Location -Path $DownloadFolderPath
[string]$InstallCmd = "$DownloadFileName -s -r -f1""%systemroot%\temp\install.iss"" /silent"
Write-Host "[Install Command] $InstallCmd"
Write-Host "Running install command, please wait... "

cmd /c $InstallCmd

Write-Host "Installation complete!"
