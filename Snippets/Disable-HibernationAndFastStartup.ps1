<#
  - [Name] Disable-HibernationAndFastStartup.ps1
  - [Description] Disables Hibernation which, as a by product, disables Fast Startup.
#>
Clear-Host
Write-Host "Disabling Hibernation, please wait..."
powercfg -h off
Write-Host "Done!"
