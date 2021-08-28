<#
    - Name: Install-Teams-x64-AllUsers
    - Summary: Downloads the Microsoft Teams client (64-Bit) and silently performs a machine-wide (All Users) installation
    - Author: Gage Faulkner (github.com/johngagefaulkner/PowerShell)
    - Last Updated: August 27th, 2021
#>
Clear-Host
Write-Host "[ Install-Teams-x64-AllUsers ]"

# Define Variables
$teamsLink = "https://teams.microsoft.com/downloads/desktopurl?env=production&plat=windows&arch=x64&managedInstaller=true&download=true"
$teamsUrl = "https://statics.teams.cdn.office.net/production-windows-x64/1.4.00.22472/Teams_windows_x64.msi"
$teamsDir = "C:\Users\Public\"
$teamsPath = "C:\Users\Public\Teams_windows_x64.msi"
$teamsArgs = 'msiexec /i Teams_windows_x64.msi OPTIONS="noAutoStart=true" ALLUSERS=1'

# DownloadMicrosoft Teams client
Write-Host "Downloading Microsoft Teams client, please wait... " -NoNewline
$ProgressPreference = 'SilentlyContinue'
Invoke-WebRequest -UseBasicParsing -Uri $teamsUrl -OutFile $teamsPath
Write-Host "Done!" -ForegroundColor Green

# Change Directory to the Directory holding the Microsoft Teams Setup File
Write-Host "Installing Microsoft Teams client, please wait... " -NoNewline
cd $teamsDir
msiexec /i Teams_windows_x64.msi OPTIONS="noAutoStart=true" ALLUSERS=1
Write-Host "Done!" -ForegroundColor Green
