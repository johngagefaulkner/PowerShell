<#
  - Name: CreateTask-PerformScheduledReboot
  - Summary: Creates a Scheduled Tasks that reboots the PC on a schedule (at a specified/date time, recurring.)
  - Author: Gage Faulkner (github.com/johngagefaulkner/PowerShell)
  - Last Updated: August 27th, 2021
  - Resources/References:
    - https://docs.microsoft.com/en-us/powershell/module/scheduledtasks/new-scheduledtask?view=windowsserver2019-ps
    - https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.management/restart-computer?view=powershell-7.1
#>
Clear-Host
Start-Transcript -Path "C:\Users\Public\Transcript-CreateTask-PerformScheduledReboot.txt" -Append -Force
Write-Host "[PowerShell Script: CreateTask-PerformScheduledReboot.ps1]"
Write-Host ' '

# Define Variables
## Run Local File:  -Argument '-File C:\scripts\Get-LatestAppLog.ps1'
$taskUrl = "https://raw.githubusercontent.com/johngagefaulkner/PowerShell/main/Cache/RebootPC.ps1"
$taskScriptPath = "C:\Scripts\RebootPC.ps1"
$taskName = "Perform Scheduled Reboot"
$taskDescription = "Restarts the PC on a specified schedule. Default is once, daily, at 3AM."
$taskAction = New-ScheduledTaskAction -Execute 'powershell.exe' -Argument '-File C:\Scripts\RebootPC.ps1'
$taskTrigger = New-ScheduledTaskTrigger -Daily -At '3:00 AM'
$myTask = New-ScheduledTask -Action $taskAction -Trigger $taskTrigger -Description $taskDescription

# Inform user the scheduled task is being created
Write-Host 'Verifying the folder "C:\Scripts\" exists... ' -NoNewline
$dirResult = New-Item -ItemType Directory -Path "C:\" -Name "Scripts" -Force |Out-Null
Write-Host "Done!" -ForegroundColor Green

Write-Host "Downloading required scripts, please wait... " -NoNewline
$ProgressPreference = 'SilentlyContinue'
#Invoke-WebRequest -UseBasicParsing -Uri $taskUrl -OutFile $taskScriptPath
Import-Module BitsTransfer -Force
Start-BitsTransfer -Source $taskUrl -Destination $taskScriptPath
Write-Host "Done!" -ForegroundColor Green

Write-Host "Creating Scheduled Task to reboot the PC daily at 3:00AM, please wait... " -NoNewline
Register-ScheduledTask $taskName -InputObject $myTask -Force |Out-Null
Write-Host "Done!" -ForegroundColor Green
Write-Host ' '
Stop-Transcript
