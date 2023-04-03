# PowerShell
Scripts that I've either written or otherwise accumulated throughout the years.

## One-Liners

### Require Elevation (Run as Administrator)
Has to be the **first** line of your PowerShell script.
```powershell
#Requires -RunAsAdministrator
```

### Set Network Security Protocol to TLS v1.2
Can be inserted anywhere before an HTTP request is made.
```powershell
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
```
