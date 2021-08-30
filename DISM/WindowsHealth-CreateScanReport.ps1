<#
    - Name: WindowsHealth-CreateScanReport
    - Summary: Runs the DISM "Scan Health" command then generates and returns a report.
    - Resources and References: https://docs.microsoft.com/en-us/windows-hardware/manufacture/desktop/repair-a-windows-image
#>
Clear-Host
Write-Host "[WindowsHealth-CreateScanReport]"

# Define Variables
$reportPath = "C:\Users\Public\WindowsHealth-ScanReport.txt"

# Inform user that the scan is starting
Write-Host "Initializing Windows Health scan, please wait... "
Repair-WindowsImage -Online -ScanHealth -NoRestart |Out-File -FilePath $reportPath
Write-Host "Done! Report saved to: $reportPath"

# Display/return the contents of the results file
Write-Host " "
$myResults = Get-Content -Path $reportPath -Raw -Force
Write-Host $myResults