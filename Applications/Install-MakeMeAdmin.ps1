<#
	- [Name] Install-MakeMeAdmin.ps1
	- [Description] Downloads and installs MakeMeAdmin v2.3.0 (64-Bit) then configures behavior settings, or policies, via Registry keys.
	- [Version] 1.02.27.1
	- [Resources and References]
		- Official Documentation | Registry Settings
			- https://github.com/pseymour/MakeMeAdmin/wiki/Registry-Settings
    - [Changelog]
        - [Feb 27, 2023] 1.02.27.1
            - [NEW] Added transcript (automatic logging) functionality
			- [NEW] Now tracks the Exit Code passed through from msiexec after installing MakeMeAdmin, stores it as an internal/private variable, then exits this script with that same Exit Code.
            - [NEW] Added "behavior" variables for ProgressPreference and ErrorActionPreference.
            - [NEW] Added an internal/private function (Invoke-Executable) to properly, and extensively, handle starting a process from PowerShell.
            - [UPDATED] Replaced "App Detection" functionality (previously checked Win32_PRODUCT via WMI Query) to now check for the full file path to the Windows Service executable (.exe)
            - [UPDATED] Refactored code related to creating Registry Keys to use variables for the Registry Key paths rather than repeating inline strings
            - [UPDATED] Changed behavior of MakeMeAdmin installation to have msiexec call the direct download URL for the .MSI file (as opposed to the previous behavior which required downloading the .MSI to a local folder on the PC first.)
#>
Start-Transcript -OutputDirectory "C:\Users\Public" -Append -Force
Clear-Host
Write-Host "[ Install-MakeMeAdmin.ps1 ]"
Write-Host "Version: 1.02.27.1"
Write-Host

# Define Behaviors
$ProgressPreference = 'SilentlyContinue'
$ErrorActionPreference = 'Stop'

# Define Variables
$APP_DOWNLOAD_URL = "https://github.com/pseymour/MakeMeAdmin/raw/v2.3-fr/Installers/en-us/MakeMeAdmin%202.3.0%20x64.msi"
$APP_DETECTION_PATH = "C:\Program Files\Make Me Admin\MakeMeAdminService.exe"
$APP_EXIT_CODE = 0
$REG_SETTINGS_ROOT = "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Sinclair Community College\Make Me Admin"
$REG_POLICIES_ROOT = "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Sinclair Community College\Make Me Admin"

# Define Functions
function Invoke-Executable {
    param(
        [parameter(Mandatory = $true, HelpMessage = "Specify the file name or path of the executable to be invoked, including the extension.")]
        [ValidateNotNullOrEmpty()]
        [string]$FilePath,

        [parameter(Mandatory = $false, HelpMessage = "Specify arguments that will be passed to the executable.")]
        [ValidateNotNull()]
        [string]$Arguments
    )
    try {
        # Create the Process Info object which contains details about the process
        $ProcessStartInfoObject = New-object System.Diagnostics.ProcessStartInfo
        $ProcessStartInfoObject.FileName = $FilePath
        $ProcessStartInfoObject.CreateNoWindow = $true
        $ProcessStartInfoObject.UseShellExecute = $false
        $ProcessStartInfoObject.RedirectStandardOutput = $true
        $ProcessStartInfoObject.RedirectStandardError = $true

        # Add the arguments to the process info object
        if ($Arguments.Count -gt 0) {
            $ProcessStartInfoObject.Arguments = $Arguments.ToString()
        }

        # Create the object that will represent the process
        $Process = New-Object -TypeName "System.Diagnostics.Process"
        $Process.StartInfo = $ProcessStartInfoObject

        # Start process
        [void]$Process.Start()

        # Wait for the process to exit
        $Process.WaitForExit()

        # Return an object that contains the exit code
        Write-Host "[Invoke-Executable] Exit Code: $Process.ExitCode"
        return "$Process.ExitCode"
    }
    catch [System.Exception] {
        Write-Host "$($MyInvocation.MyCommand): Error message: $($_.Exception.Message)"
        return "99"
    }
}

# Initialize (launch main part of) script
Write-Host "Determining whether MakeMeAdmin is already installed, please wait..."

# If the MakeMeAdmin service executable isn't found, the app needs to be downloaded and installed.
if (!(Test-Path $APP_DETECTION_PATH)) {
    Write-Host "MakeMeAdmin installation not detected!"
    Write-Host "Installing MakeMeAdmin, please wait..."
    Set-Location -Path "C:\Windows\System32"
    $APP_EXIT_CODE = Invoke-Executable -FilePath "C:\Windows\System32\cmd.exe" -Arguments "msiexec /i ""$APP_DOWNLOAD_URL"" /qn"
    Write-Host "Installation complete!"
}
else {
    Write-Host "MakeMeAdmin is already installed!"
}

# Create the MakeMeAdmin key and set the AdminRightTimeout value to 60 minutes
Write-Host "Configuring MakeMeAdmin behavior settings via Registry, please wait..."

if (!(Test-Path -Path $REG_SETTINGS_ROOT)) {
    New-Item -Path $REG_SETTINGS_ROOT -Force
    Write-Host "Created: $REG_SETTINGS_ROOT"
}
else {
    Write-Host "$REG_SETTINGS_ROOT already exists!"
}

New-ItemProperty -Path $REG_SETTINGS_ROOT -Name "MakeMeAdmin" -Value "" -Force
Write-Host "Created $REG_SETTINGS_ROOT\MakeMeAdmin"
New-ItemProperty -Path $REG_SETTINGS_ROOT -Name "AdminRightTimeout" -Value "60" -PropertyType DWORD -Force
Write-Host "Created $REG_SETTINGS_ROOT\AdminRightsTimeout with a value of '60' (minutes.)"
Write-Host "Custom configuration successfully applied!"

# End
Write-Host "Operation completed successfully!"
Stop-Transcript
Exit $APP_EXIT_CODE
