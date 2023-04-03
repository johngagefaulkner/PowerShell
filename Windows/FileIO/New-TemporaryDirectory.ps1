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
$dir = New-TemporaryDirectory
Write-Host "Temporary directory created: $dir"
