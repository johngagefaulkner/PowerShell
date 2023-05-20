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

---

# To-Do Items

- Create a new file named `Wait-Reboot.ps1` and populate it with the following content:

```powershell
Add-Type -Namespace Ansible.WinReboot -Name Native -MemberDefinition @'
[DllImport("Advapi32.dll", CharSet = CharSet.Unicode)]
public static extern Int32 RegQueryInfoKeyW(
    SafeHandle hKey,
    IntPtr lpClass,
    ref UInt32 lpcchClass,
    IntPtr lpReserved,
    out UInt32 lpcSubKeys,
    out UInt32 lpcbMaxSubKeyLen,
    out UInt32 lpcbMaxClassLen,
    out UInt32 lpcValues,
    out UInt32 lpcbMaxValueNameLen,
    out UInt32 lpcbMaxValueLen,
    out UInt32 lpcbSecurityDescriptor,
    out System.Runtime.InteropServices.ComTypes.FILETIME lpftLastWriteTime
);
'@

$bootTime = (Get-CimInstance -ClassName Win32_OperatingSystem -Property LastBootUpTime).LastBootUpTime.ToUniversalTime()
Write-Host "Boot Time: $($bootTime.ToString("o"))"

while ($true) {
    $regPath = 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\AutoLogonChecked'
    if (-not (Test-path -LiteralPath $regPath)) {
        Write-Host "Key does not exist"
        Start-Sleep -Seconds 5
        continue
    }

    $key = Get-Item -LiteralPath $regPath
    try {
        
        $lastWriteTime = New-Object -TypeName Runtime.InteropServices.ComTypes.FILETIME
        $res = [Ansible.WinReboot.Native]::RegQueryInfoKeyW(
            $key.Handle,
            [IntPtr]::Zero,
            [ref]$null,
            [IntPtr]::Zero,
            [ref]$null,
            [ref]$null,
            [ref]$null,
            [ref]$null,
            [ref]$null,
            [ref]$null,
            [ref]$null,
            [ref]$lastWriteTime
        )
        if ($res -ne 0) {
            $exp = [ComponentModel.Win32Exception]$res
            Write-Host "Failed $($res): $($exp.Message)"
        }
        else {
            $highFT = [UInt32]("0x{0:X8}" -f $lastWriteTime.dwHighDateTime)
            $lowFT = [UInt32]("0x{0:X8}" -f $lastWriteTime.dwLowDateTime)

            $regTime = [DateTime]::FromFileTimeUtc(([Int64]$highFT -shl 32) -bor $lowFT)
            Write-Host "Reg Time: $($regTime.ToString("o"))"
            if ($regTime -ge $bootTime) {
                Write-Host "Reg time has been updated"
                break
            }
        }

        Write-Host "Sleep for 5 seconds"
        Start-Sleep -Seconds 5
    }
    finally {
        $key.Dispose()
    }
}
```