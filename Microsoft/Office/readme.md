# PowerShell Snippets
## Microsoft Office

These scripts and/or snippets have been collected from all over but are usually from either the Microsoft Docs articles or from random comments by Microsoft employees left on GitHub issues/projects/etc. 

For example, this excerpt installs Microsoft Office using the Office Deployment Tool and is from the Microsoft Surface Deployment Accelerator repo:

```powershell
Set-Location ($env:Temp + '\Office365')
$Process = (Start-Process "setup.exe" -ArgumentList "/configure .\O365_configuration.xml" -Wait -PassThru)
$Process.WaitForExit()
exit(0)
```
