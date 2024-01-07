<#
  - Name: Enable-LocalAdmin.ps1
  - Summary: This script generates a random, 24-character, password using the public API made available from PasswordWolf.com, then enables the Local Administrator account and sets the password to the randomly-generated password.
#>

# Define Variables
$PasswordGeneratorAPI = "https://passwordwolf.com/api/?length=24&exclude=&repeat=1"

# Init
Write-Host "Generating random password, please wait... " -NoNewline
$PasswordRequest = Invoke-WebRequest -Uri $PasswordGeneratorAPI -UseBasicParsing
$PasswordResponse = $PasswordRequest.Content | ConvertFrom-Json
$PasswordResult = $PasswordResponse.password
$SecurePassword = ConvertTo-SecureString "$PasswordResult" -AsPlainText -Force
Write-Host "Done!"

Write-Host "Enabling the Local Administrator account and setting the password... " -NoNewline
$adminAccount = Get-LocalUser -Name "Administrator" # Get the local administrator account
$adminAccount | Enable-LocalUser # Enable the administrator account
$adminAccount | Set-LocalUser -Password $SecurePassword # Set the password for the administrator account
Write-Host "Done!"

# Verify if the account is enabled
if ($adminAccount.Enabled) {
    Write-Host "Successfully enabled the Administrator account!"
	Write-Host "Password: $PasswordResult"
} else {
    Write-Host "Failed to enable Administrator account! Please try again."
}
