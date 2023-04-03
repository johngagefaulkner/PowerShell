# Define Behavior
$ProgressPreference = 'SilentlyContinue'
$ErrorActionPreference = 'Continue'

# Define Variables
$exeFilePath = "C:\Users\JohnDoe\Downloads\Installer.msi"
$exeArgs = "setup"

Start-Process -FilePath "$exeFilePath" -ArgumentList "$exeArgs" -NoNewWindow -Wait -ErrorAction Continue
