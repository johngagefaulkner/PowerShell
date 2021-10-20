<#
    - Name:  Rename-TPMCredentialStore.ps1
    - Description: Renames the folders containing cached credential data for the Microsoft AAD Broker Plugin and "Microsoft Accounts Control."
    - Author: Gage Faulkner (gfaulkner@atlantaga.gov)
    - Last Updated: October 20th, 2021
#>
Clear-Host

<#  EXIT CODES
    - 0: Success
    - 1: Failed to find the User Profile entered by the user
    - 2: Failed to find the "Microsoft.AAD.BrokerPlugin" folder for the selected User Profile.
    - 3: Failed to find the "Microsoft.AccountsControl" folder for the selected User Profile.
    - 4: The selected user was logged into the PC.
#>

# Define Variables
$selectedUser = ""
$aadBrokerDirPath = "C:\Users\^user^\AppData\Local\Packages\Microsoft.AAD.BrokerPlugin_cw5n1h2txyewy"
$aadBrokerNewName = "OLD_Microsoft.AAD.BrokerPlugin_cw5n1h2txyewy"
$accControlDirPath = "C:\Users\^user^\AppData\Local\Packages\Microsoft.AccountsControl_cw5n1h2txyewy"
$accControlNewName = "OLD_Microsoft.AccountsControl_cw5n1h2txyewy"
$loggedOnFullUserName = (Get-CimInstance -ClassName Win32_ComputerSystem).Username
$loggedOnUser = ((Get-CimInstance -ClassName Win32_ComputerSystem).Username).Split('\')[1]

Write-Host "[ Rename-TPMCredentialStore ]"
Write-Host "Renames the folders containing cached credential data for the Microsoft AAD Broker Plugin and 'Microsoft Accounts Control.'"
Write-Host " "

Write-Host "[User Profile Names]"
Get-ChildItem "C:\Users" |Select-Object -ExpandProperty "Name"
Write-Host " "
$selectedUser = Read-Host -Prompt "Please type the EXACT name of the affected User Profile"
Write-Host " "
$testDirPath = "C:\Users\$selectedUser"

if ((Test-Path -Path $testDirPath) -eq $false) {
    Write-Host "The User Profile name you entered was not found. Please try again." -ForegroundColor Yellow
    Exit 1
} else {
    
    if ($loggedOnUser.Contains($selectedUser)) {
        Write-Warning "The selected user is currently logged into the PC. Please have them logout then try again."
        Write-Host "Exit Code: 4"
        Exit 4
    }
    $aadBrokerDirPath = $aadBrokerDirPath.Replace("^user^", $selectedUser)
    $accControlDirPath = $accControlDirPath.Replace("^user^", $selectedUser)

    Write-Host "[Applying Folder Changes...]"
    Write-Host " - Microsoft AAD Broker Plugin: " -NoNewline
    if ((Test-Path -Path $aadBrokerDirPath) -eq $false) {
        Write-Host "Not found." -ForegroundColor Red
        Exit 2
    } else {
        Write-Host "Found!" -ForegroundColor Green
        Write-Host " - Microsoft AAD Broker Plugin: Applying fix... " -NoNewline
        Rename-Item -Path $aadBrokerDirPath -NewName $aadBrokerNewName -Force
        Write-Host "Success!" -ForegroundColor Green
    }
    Write-Host " - Microsoft Accounts Control: " -NoNewline
    if ((Test-Path -Path $accControlDirPath) -eq $false) {
        Write-Host "Not found." -ForegroundColor Red
        Exit 3
    } else {
        Write-Host "Found!" -ForegroundColor Green
        Write-Host " - Microsoft Accounts Control: Applying fix... " -NoNewline
        Rename-Item -Path $accControlDirPath -NewName $accControlNewName -Force
        Write-Host "Success!" -ForegroundColor Green
    }

    Write-Host "Operation completed successfully! Please have the user log back into their User Profile and open Outlook."
}
