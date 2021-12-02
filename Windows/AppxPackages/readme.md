# AppxPackages
These scripts interact with both AppxPackages and AppxProvisionedPackages in Windows 10 and Windows 11.

- **Requires PowerShell 7:** [Download](https://aka.ms/powershell-release?tag=stable)

---
## AppxProvisionedPackages
- **Description:** Obtains a list of all `AppxProvisionedPackages` from the online (running) Operating System.
- **Script Output:** Results are trimmed, including only the `Version`, `Package Name`, `Display Name` and `Install Location`, converted to JSON and exported to a file in the `C:\Users\Public\` directory.
- **Reference:** https://docs.microsoft.com/en-us/powershell/module/dism/get-appxprovisionedpackage?view=windowsserver2019-ps
- **Script Example:** Requires PowerShell to be running elevated (as an Administrator.)

```powershell
Get-AppxProvisionedPackage -Online |Select-Object Version,PackageName,DisplayName,InstallLocation -ExcludeProperty "CIM*" |ConvertTo-Json -EnumsAsStrings |Out-File -FilePath "C:\Users\Public\SystemAppxProvisionedPackageList.json"
```
---
## AppxPackages
- **Description:** Obtains a list of all `AppxPackages` installed for All Users on the PC.
- **Script Output:** Results are trimmed, including only the `Name`, `Version`, `Package Family Name`, `Package Full Name` and `Install Location`, converted to JSON and exported to a file in the `C:\Users\Public\` directory.
- **Script Example:** Requires PowerShell to be running elevated (as an Administrator.)

```powershell
Get-AppxPackage -AllUsers |Select-Object Name,Version,PackageFamilyName,PackageFullName,InstallLocation -ExcludeProperty "CIM*" |ConvertTo-Json -EnumsAsStrings |Out-File -FilePath "C:\Users\Public\SystemAppxPackageList.json"
```
---
## Installed Apps
- **Description:** Gets the names and AppIDs of installed apps.
- **Script Output:** The Get-StartApps cmdlet gets the names and AppIDs of installed apps of the current user. An AppID is an AppUserModelID. You can specify a particular app by using its name, or you can specify a name that includes the wildcard character (*). If you do not specify a name, the cmdlet displays all installed apps.
- **Reference:** https://docs.microsoft.com/en-us/powershell/module/startlayout/get-startapps?view=windowsserver2019-ps
- **Script Example:** Does **not** require PowerShell to be running elevated.

```powershell
Get-StartApps |ConvertTo-Json
```
