<#
  New-TemporaryDirectory.ps1
  Creates a new temporary directory.
#>

$ErrorActionPreference = 'Stop'

function New-TemporaryDirectory {
    $parent = [System.IO.Path]::GetTempPath()
    [string] $name = [System.Guid]::NewGuid()
    New-Item -ItemType Directory -Path (Join-Path $parent $name)
}

Clear-Host
Write-Host "[ New-TemporaryDirectory.ps1 ]"
Write-Host "Creating new temporary directory..."
$tempDir = New-TemporaryDirectory
Write-Host "Temporary directory created: $dir"

Read-Host -Prompt "Press Enter to continue and delete the temporary folder"
Remove-Item $tempDir -Recurse -Force
