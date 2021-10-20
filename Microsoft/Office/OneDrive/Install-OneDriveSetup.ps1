<#
    - Name: Install-OneDriveWithOptions.ps1
    - Description: Provides simple, easy, access to download and install OneDrive with options like 32-Bit (x86) or 64-Bit (x64), User-Context or Device-Context, etc.
    - Author: Gage Faulkner (gfaulkner@atlantaga.gov)
    - Last Updated: October 20th, 2021
#>
Clear-Host
Write-Host "[ Install-OneDriveWithOptions.ps1 ]"
Write-Host " "

# Define Variables
$rootDir = "C:\MDM\"
$cachePath = "C:\MDM\Cache\"
$logPath = "C:\MDM\Cache\OneDriveSetup.log"
$filePath = "C:\MDM\Cache\OneDriveSetup.exe"
$fileUrl = "https://oneclient.sfx.ms/Win/Insiders/21.139.0711.0001/amd64/OneDriveSetup.exe"
$ProgressPreference = 'SilentlyContinue'

# Initialize Log
Start-Transcript -Path $logPath -IncludeInvocationHeader -Append -Force
Write-Information "Log initialized..."

# Download the OneDrive Setup utility
Write-Information "Downloading OneDrive client, please wait..."
Invoke-WebRequest -Uri $fileUrl -UseBasicParsing -OutFile $filePath
Write-Information "Download complete!"

# Kill all running instances of OneDrive
Write-Information "Killing all instances of OneDrive, please wait..."
taskkill /im onedrive.exe /f
#$procResult = Get-Process -Name "OneDrive.exe" |Stop-Process

# Launch the OneDrive installation
Write-Information "Launching OneDriveSetup.exe, please wait... "
Start-Process -FilePath "OneDriveSetup.exe" -WorkingDirectory $cachePath -Verb RunAs -ArgumentList "/allusers"
Write-Information "OneDriveSetup launched successfully!"

# Stop logging, append remaining data and dispose unused resources
Stop-Transcript
