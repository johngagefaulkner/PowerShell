# Microsoft / Intune / Autopilot

## Perform Manual Device Enrollment

```powershell
# To directly capture the hardware hash from the local computer, use the following commands from an elevated Windows PowerShell prompt:
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
New-Item -Type Directory -Path "C:\HWID"
Set-Location -Path "C:\HWID"
$env:Path += ";C:\Program Files\WindowsPowerShell\Scripts"
Set-ExecutionPolicy -Scope Process -ExecutionPolicy RemoteSigned
Install-Script -Name Get-WindowsAutopilotInfo
Get-WindowsAutopilotInfo -OutputFile AutopilotHWID.csv

# While OOBE is running, you can start uploading the hardware hash by opening a command prompt (Shift+F10 at the sign-in prompt) and using the following commands:
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
PowerShell.exe -ExecutionPolicy Bypass
Install-Script -name Get-WindowsAutopilotInfo -Force
Set-ExecutionPolicy -Scope Process -ExecutionPolicy RemoteSigned
Get-WindowsAutopilotInfo -Online
```

# Resources and References

- [Microsoft Docs | Manually Enroll Device into Autopilot](https://learn.microsoft.com/en-us/mem/autopilot/add-devices)
