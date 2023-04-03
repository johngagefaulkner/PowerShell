# Get-JsonFromAPI.ps1

# Define Behaviors
$ProgressPreference = 'SilentlyContinue'
$ErrorActionPreference = 'Stop'

# Define Variables
$url = "https://registry.npmjs.org/@pnpm/exe"
$path = ""

Clear-Host

$pkgInfo = Invoke-WebRequest "$url" -UseBasicParsing
$versionJson = $pkgInfo.Content | ConvertFrom-Json
$versions = Get-Member -InputObject $versionJson.versions -Type NoteProperty | Select-Object -ExpandProperty Name
$distTags = Get-Member -InputObject $versionJson.'dist-tags' -Type NoteProperty | Select-Object -ExpandProperty Name
