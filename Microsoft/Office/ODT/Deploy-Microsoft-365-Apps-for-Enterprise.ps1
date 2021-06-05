<#
    - [Summary] Downloads and Installs Microsoft 365 Apps for Enterprise

    - [Prerequisites]
        - Using the links below (in the resources section), download the Office Deployment Tool and create a custom ODT configuration.
        - You will need to extract "Setup.exe" from the ODT
        - You will need to host the "Setup.exe" and your custom configuration "*.xml" somewhere they're publicly-available.
            - GitHub has free public storage.
            - Google Firebase has a generous free tier (5GB total, 1GB daily bandwidth, 50,000 daily download operations.) 
                - The ODT "Setup.exe" is ~6.3MB which means you could run this script on ~160 devices per day on the free tier.
        - [IMPORTANT!] If you're using the configuration file provided by me, edit the organization name in the XML file.
        - Configure the variables in the first part of the script below.

    - [Description] 
        - 1.) Creates a folder on the end-user's PC at "C:\ODT"
        - 2.) Downloads the Office Deployment Tool (ODT)
        - 3.) Downloads your customized configuration for ODT (*.xml)
        - 4.) Runs the ODT tool passing your XML file as a parameter to install the Office 365 suite.

    - [Resources]
        - Office Deployment Tool: https://www.microsoft.com/en-us/download/details.aspx?id=49117
        - ODT Configuration Tool: https://config.office.com/deploymentsettings
        - Microsoft Documentation: https://docs.microsoft.com/en-us/DeployOffice/overview-of-the-office-customization-tool-for-click-to-run
#>
Clear-Host

## Variables
$odtDir = "C:\ODT"
$odtPath = "C:\ODT\Setup.exe"
$odtUrl = "https://raw.githubusercontent.com/johngagefaulkner/PowerShell/main/Microsoft/Office/ODT/setup.exe"
$configUrl = "https://raw.githubusercontent.com/johngagefaulkner/PowerShell/main/Microsoft/Office/ODT/Configurations/Custom-Microsoft-365-Apps-for-Enterprise-Configuration.xml"
$configPath = "C:\ODT\Custom-Microsoft-365-Apps-for-Enterprise-Configuration.xml"
$logPath = "C:\ODT\Install.log"

## Logging Function (No changes needed; changing configuration is optional)
Function Log {
    param(
        [Parameter(Mandatory=$true)][String]$msg
    )
    
    $logTime = (Get-Date).ToString()
    $logMsg = "[$logTime] $msg"
    Add-Content -Path $logPath -Value $logMsg
}

## [Step 1] Create directory and download files.

# [1a] Create the directory
$dirResult = New-Item -Path "C:\" -Name "ODT" -ItemType Directory -Force
Log("Launching Microsoft 365 Apps for Enterprise installation, please wait...")
Log("Created Directory: $odtDir")

# [1b] Download ODT's Setup.exe
Log("Downloading ODT's Setup.exe, please wait...")
Log("Configured ODT Download URL: $odtUrl");
(New-Object System.Net.WebClient).DownloadFile($odtUrl, $odtPath)
Log("Download Complete: $odtPath")

# [1c] Download the Configuration file (*.xml)
Log("Downloading Configuation file, please wait...")
Log("Configured .XML Download URL: $configUrl")
(New-Object System.Net.WebClient).DownloadFile($configUrl, $configPath)
Log("Download Complete: $configPath")

## [Step 2] With the files downloaded, we can launch the installation
Log("Launching 'Setup.exe' with params '/configure' and $configPath")
Start-Process -FilePath $odtPath -WorkingDirectory $odtDir -ArgumentList "/configure $configPath" -NoNewWindow -Wait
Log("Installation completed successfully!")