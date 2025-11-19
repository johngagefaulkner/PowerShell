$ProgressPreference = 'SilentlyContinue'
$ErrorActionPreference = 'Stop'

<#
  - Written for a friend of mine who was running out of storage space on his Windows OS `C:` partition.
  - Intended to be used from CMD via, for example, something like this: 
    - powershell -ep bypass -nop -command "iwr https://raw.githubusercontent.com/johngagefaulkner/PowerShell/refs/heads/main/Windows/Optimizations/Start-TempStorageCleanup.ps1 | iex"
#>

Clear-Host
Write-Host "[ Start-TempStorageCleanup.ps1 ]" -ForegroundColor Cyan
Write-Host

# Prompt user for age threshold
[int]$days = Read-Host "Enter the number of days (e.g., 5 to delete files older than 5 days)"

# Define the temp path
$TempPath = $env:TEMP

# Get candidate files and folders
$cutoffDate = (Get-Date).AddDays(-$days)
$items = Get-ChildItem -Path $TempPath -Recurse -Force -ErrorAction SilentlyContinue | Where-Object {
    $_.LastWriteTime -lt $cutoffDate
}

# Calculate stats
$totalSize = ($items | Measure-Object -Property Length -Sum).Sum
$fileCount = ($items | Where-Object { -not $_.PSIsContainer }).Count
$folderCount = ($items | Where-Object { $_.PSIsContainer }).Count
$sizeMB = [math]::Round($totalSize / 1MB, 2)

# Display summary
Write-Host "`nFound $fileCount files and $folderCount folders older than $days days."
Write-Host "Total size to be freed: $sizeMB MB`n"

# Confirm deletion
$confirm = Read-Host "Do you want to proceed with deletion? (Y/N)"
if ($confirm -match '^[Yy]$') {
    $items | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue
    Write-Host "`nDeletion complete."
} else {
    Write-Host "`nOperation cancelled."
}
