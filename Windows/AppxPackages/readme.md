# AppxPackages
These scripts interact with both AppxPackages and AppxProvisionedPackages in Windows 10 and Windows 11.

---
## AppxProvisionedPackages
- **Description:** Obtains a list of all `AppxProvisionedPackages` from the online (running) Operating System.
- **Script Output:** Results are trimmed, including only the `Version`, `Package Name`, `Display Name` and `Install Location`, converted to JSON and exported to a file in the `C:\Users\Public\` directory.
- **Script Example:** Using PowerShell 7.20

```powershell
Get-AppxProvisionedPackage -Online |Select-Object Version,PackageName,DisplayName,InstallLocation -ExcludeProperty "CIM*" |ConvertTo-Json -EnumsAsStrings |Out-File -FilePath "C:\Users\Public\SystemAppxProvisionedPackageList.json"
```
---
## AppxPackages

```powershell
Get-AppxPackage -AllUsers |Select-Object Name,Version,PackageFamilyName,PackageFullName,InstallLocation -ExcludeProperty "CIM*" |ConvertTo-Json -EnumsAsStrings |Out-File -FilePath "C:\Users\Public\SystemAppxPackageList.json"
```