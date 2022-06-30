# Define Process/Environment Variables
$ProgressPreference = 'SilentlyContinue'
$ErrorActionPreference = 'Exit'

# Define Script Variables
$ODTDir = Join-Path -Path $env:Temp -ChildPath "ODT"
$ODTSetupPath = Join-Path -Path $ODTDir -ChildPath "setup.exe"
$ODTConfigPath = Join-Path -Path $ODTDir -ChildPath "config.xml"

# Define Functions

function Warn-AndExit([string]$WarningMsg, [int]$UserExitCode)
{
    Write-Warning $WarningMsg
    Read-Host -Prompt "Press any key to exit"
    exit $UserExitCode
}

function New-ODTInstallation([string]$UrlToSetupEXE, [string]$UrlToConfigXML, [switch]$DownloadOnly, [switch]$Install)
{
    if ($DownloadOnly -and $Install) {
        Warn-AndExit -WarningMsg "Both 'DownloadOnly' and 'Install' methods were selected! Please try again and choose only 1 of the 2 methods." -UserExitCode 3
    }

    if (!$DownloadOnly -and !$Install) {
        Warn-AndExit -WarningMsg "No method of action was chosen! Please try again and select either the '-DownloadOnly' or '-Install' method to continue!" -UserExitCode 4
    }

    if ($UrlToSetupEXE -eq "") {
        Warn-AndExit -WarningMsg "The 'UrlToSetupEXE' parameter was left blank! Please provide the URL to download the 'Setup.exe' (included with the ODT.)" -UserExitCode 5
    }

    if ($UrlToConfigXML -eq "") {
        Warn-AndExit -WarningMsg "The 'UrltoConfigXML' parameter was left blank! Please provide the URL to download your customized ODT configuration file (*.xml)" -UserExitCode 6
    }

    Set-Location $ODTDir
    Write-Host "Initiating 'New-ODTInstallation' function!"    
    Write-Host "Processing downloads, please wait... "
    Write-Host "Downloading ODT Setup.exe, please wait... " -NoNewline
    Invoke-WebRequest -UseBasicParsing -Uri $UrlToSetupEXE -OutFile $ODTSetupPath | Out-Null
    Write-Host "Done!" -ForegroundColor Green
    Write-Host "Downloading ODT Config.xml, please wait... " -NoNewline
    Invoke-WebRequest -UseBasicParsing -Uri $UrlToConfigXML -OutFile $ODTConfigPath | Out-Null
    Write-Host "Done!" -ForegroundColor Green
    Write-Host "Successfully downloaded all required files!" -ForegroundColor Green
    Write-Host "Launching Office Deployment Tool, please wait... "    
    
    if ($DownloadOnly) {
        $Process = (Start-Process "setup.exe" -ArgumentList "/download .\config.xml" -NoNewWindow -Wait -PassThru)
        $Process.WaitForExit()
    }

    if ($Install) {
        $Process = (Start-Process "setup.exe" -ArgumentList "/configure .\config.xml" -NoNewWindow -Wait -PassThru)
        $Process.WaitForExit()
    }

    Write-Host "Operation completed successfully!" -ForegroundColor Green
    Read-Host -Prompt "Press any key to exit..."
    exit 0
}

# Initialize Script
Clear-Host
Write-Host "[ Install-OfficeUsingODT.ps1 ]"
Write-Host

# Process Prerequisites
Write-Host "Processing Prerequisites, please wait..."
Write-Host "Checking if installation directory exists... " -NoNewline

if (Test-Path $ODTDir) {
    Write-Host "Directory found!" -ForegroundColor Green
} else {
    Write-Host "Directory not found!" -ForegroundColor Yellow
    Write-Host "Attempting to create the folder, please wait... " -NoNewline
    New-Item -Path $env:Temp -Name "ODT" -ItemType "Directory" -Force | Out-Null

    if (Test-Path $ODTDir) {
        Write-Host "Done!" -ForegroundColor Green
    } else {
        Write-Host "Error!" -ForegroundColor Red
        Write-Warning "Failed to create the required directories! Please try again and ensure you're running as an Administrator. Script will exit."
        Read-Host -Prompt "Press any key to exit..."
        Exit 1
    }
}

# Init
$UserSetupUrl = Read-Host -Prompt "Enter URL to Setup.exe"
$UserConfigUrl = Read-Host -Prompt "Enter URL to Config.xml"
New-ODTInstallation -UrlToSetupEXE $UserSetupUrl -UrlToConfigXML $UserConfigUrl -DownloadOnly
