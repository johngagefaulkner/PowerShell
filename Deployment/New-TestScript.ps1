<#
    - Name: New-TestScript.ps1
    - Description: This script was created to test PowerShell script deployment methods simply creating a text file at "C:\ProgramData\PowerShellTestScript.txt" to determine whether your deployment method(s) are successful.
    - Version: 1.0.0
    - Created: 2022-07-25
    - Author: John Gage Faulkner (gfaulkner@atlantaga.gov)
#>
Clear-Host
Write-Host "[ New-TestScript.ps1 ]: Starting..."
Write-Host "[ New-TestScript.ps1 ]: Creating file at C:\ProgramData\PowerShellTestScript.txt"
$file = "C:\ProgramData\PowerShellTestScript.txt"
$content = "This is a test file created by PowerShell script deployment method(s)..."
$encoding = [System.Text.Encoding]::UTF8
$content | Out-File $file -Encoding $encoding -Force
Write-Host "[ New-TestScript.ps1 ]: File created successfully!"
exit 0
