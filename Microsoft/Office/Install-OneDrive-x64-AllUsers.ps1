<#
    - Name: Install-OneDrive-x64-AllUsers
    - Summary: Downloads the Microsoft OneDrive client (64-Bit) and silently performs a machine-wide (All Users) installation
    - Author: Gage Faulkner (github.com/johngagefaulkner/PowerShell)
    - Last Updated: August 27th, 2021
#>
Clear-Host
Write-Host "[ Install-OneDrive-x64-AllUsers ]"

# Define Variables
$oneDriveLink = "https://aka.ms/onedrive-64-bit-preview"
$oneDriveUrl = "https://oneclient.sfx.ms/Win/Insiders/21.139.0711.0001/amd64/OneDriveSetup.exe"
$oneDriveDir = "C:\Users\Public\"
$oneDrivePath = "C:\Users\Public\OneDriveSetup.exe"
$oneDriveArgs = "OneDriveSetup.exe /allusers"

# Download OneDrive client
Write-Host "Downloading Microsoft OneDrive client, please wait... " -NoNewline
$ProgressPreference = 'SilentlyContinue'
Invoke-WebRequest -UseBasicParsing -Uri $oneDriveUrl -OutFile $oneDrivePath
Write-Host "Done!" -ForegroundColor Green

# Change Directory to the OneDrive Setup File
Write-Host "Installing Microsoft OneDrive client, please wait... " -NoNewline
cd $oneDriveDir
.\OneDriveSetup.exe /allusers
Write-Host "Done!" -ForegroundColor Green
