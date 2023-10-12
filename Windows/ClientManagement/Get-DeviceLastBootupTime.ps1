<#
  - NOTE: This PowerShell script has been carefully written and rewritten many times over with the help of multiple GitHub users to ensure it properly accounts for whether Fast Startup is enabled on the device where the script is running.
#>

$ProgressPreference = 'SilentlyContinue'
$ErrorActionPreference = 'Stop'
Write-Host "[ Get-DeviceLastBootupTimeWithFastStartup.ps1 ]" -ForegroundColor Green
Write-Host "Determining whether Fast Startup is enabled, please wait... " -NoNewline

# Define Variables
$RebootThresholdInDays = 7
$FastStartupRegistryKeyPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Power"
$IsFastStartupEnabled = (Get-ItemProperty $FastStartupRegistryKeyPath -ErrorAction SilentlyContinue).HiberbootEnabled
Write-Host "Done!" -ForegroundColor Green

# Determine the last bootup time based on Fast Startup setting
$LastOSBootupTime = if ($IsFastStartupEnabled -eq 1) {
    Write-Host "[Fast Startup] Enabled"
    $LatestBootupEvent = Get-WinEvent -ProviderName "Microsoft-Windows-Kernel-Boot" | Where-Object { $_.ID -eq 27 -and $_.Message -like "*0x1*" }
    $LatestBootupEvent[0].TimeCreated
}
elseif (($null -eq $IsFastStartupEnabled) -or ($IsFastStartupEnabled -eq 0)) {
    Write-Host "[Fast Startup] Disabled"
    (Get-CimInstance Win32_OperatingSystem).LastBootUpTime
}
else {
    Write-Host "[WARNING] Unable to determine whether Fast Startup is enabled. Script exiting with exit code 1." -ForegroundColor Yellow
    exit 1
}

# Calculate OS Uptime
if ($null -ne $LastOSBootupTime) {
    Write-Host "[Last OS Bootup Time] $LastOSBootupTime"
    $OsUptime = (Get-Date) - $LastOSBootupTime
    $OsUptimeInDays = $OsUptime.Days
    $OsUptimeInHours = $OsUptime.Hours
    $OsUptimeInMinutes = $OsUptime.Minutes
    Write-Host "[Operating System Uptime] $OsUptimeInDays day(s), $OsUptimeInHours hour(s), $OsUptimeInMinutes minute(s)"

    # Check if reboot is needed
    if ($OsUptimeInDays -ge $RebootThresholdInDays) {
        Write-Host "Uptime threshold ($RebootThresholdInDays days) has been met or exceeded."
        Write-Host "[Result] " -NoNewLine
        Write-Host "Reboot required." -ForegroundColor Yellow
        exit 2
    }
    else {
        Write-Host "Uptime threshold ($RebootThresholdInDays days) has not been met."
        Write-Host "[Result] " -NoNewline
        Write-Host "No reboot required." -ForegroundColor Green
        exit 0
    }
}
else {
    Write-Host "[WARNING] Unable to determine how long the Operating System has been running. Script exiting with exit code 1." -ForegroundColor Yellow
    exit 1
}
