# Intune Management Extension

All sorts of notes, tricks, tips, etc. related to the Intune Management Extension.

## Get Info

- **Determine Enrollment Status:** In CMD: `dsregcmd /status`

## File Paths

- **Intune Windows Agent:** `"C:\Program Files (x86)\Microsoft Intune Management Extension\Microsoft.Management.Services.IntuneWindowsAgent.exe"`
- **IME Logs:** `C:\ProgramData\Microsoft\IntuneManagementExtension\Logs`

## Force MDM Sync or Check-In

- General consensus for best practice is to restart the service: `Net Stop IntuneManagementEngine && Net Start IntuneManagementEngine`

## Registry Keys

- **Deployed Script Info:** `HKLM\SOFTWARE\Microsoft\IntuneManagementExtension\Policies\`

---

# Blog Posts and Articles

- [Troubleshooting Win32 App Deployments in Intune](https://ccmexec.com/2019/08/troubleshooting-intune-win32app-deployments/)
- https://jannikreinhard.com/2022/07/31/summary-of-the-intune-management-extension/
- https://www.petervanderwoude.nl/post/combining-the-powers-of-the-intune-management-extension-and-chocolatey/
- https://timmyit.com/2019/06/04/intune-invoke-sync-to-all-devices-in-intune-with-the-intune-powershell-sdk/
- https://smsagent.blog/2018/09/20/intune-client-side-logs-in-windows-10/
- https://www.prajwaldesai.com/deploy-powershell-script-using-intune-mem/
- https://powershellisfun.com/2022/09/12/read-intunemanagementextension-logs-using-powershell/
- https://oliverkieselbach.com/2020/11/03/triggering-intune-management-extension-ime-sync/
- https://oliverkieselbach.com/2018/02/12/part-2-deep-dive-microsoft-intune-management-extension-powershell-scripts/
- https://github.com/microsoftgraph/powershell-intune-samples/blob/master/DeviceConfiguration/DeviceManagementScripts_Get.ps1
- https://www.anoopcnair.com/intune-management-extension-deep-dive-level-300/
- https://oofhours.com/2019/09/28/forcing-an-mdm-sync-from-a-windows-10-client/
- https://itpro-tips.com/force-intune-settings-sync-on-computers/
- https://powers-hell.com/2018/04/16/how-to-force-intune-configuration-scripts-to-re-run/
- https://oliverkieselbach.com/2018/10/02/part-3-deep-dive-microsoft-intune-management-extension-win32-apps/
- https://gist.githubusercontent.com/okieselbach/4f11ba37a6848e08e8f82d9f2ffff516/raw/1123d1032c15e70cffa836e64624e9df73c16da0/IntunePSTemplate.ps1
