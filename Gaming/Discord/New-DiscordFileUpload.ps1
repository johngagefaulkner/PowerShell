<#
.SYNOPSIS
    This script is used to upload a file to Discord.
#>
$ProgressPreference = 'SilentlyContinue'
$ErrorActionPreference = 'Stop'
Clear-Host

# Define Variables
$hookurl = "https://discord.com/api/webhooks/1125728627888234516/SFmXm6VlWQSp3IfBJJu8kqAJ0gnXnc3uDJeh4-LwwIS9Rf5MS1p62RblonxyQuEr0DNN"

# Define Functions
function New-DiscordFileUpload {

    [CmdletBinding()]
    param (
        [parameter(Position = 0, Mandatory = $False)]
        [string]$file,
        [parameter(Position = 1, Mandatory = $False)]
        [string]$text
    )

    $Body = @{
        'username' = $env:username
        'content'  = $text
    }

    if (-not ([string]::IsNullOrEmpty($text))) {
        Invoke-RestMethod -ContentType 'Application/Json' -Uri $hookurl -Method Post -Body ($Body | ConvertTo-Json)
    };

    if (-not ([string]::IsNullOrEmpty($file))) {
        #Invoke-RestMethod -Uri $hookurl -Method Post -F "file1=@$file" $hookurl
        #$fileContent = Get-Content -Path $file -Raw
        #Invoke-RestMethod -Uri $hookurl -Method Post -Body @{file1 = $fileContent } -ContentType 'multipart/form-data' #application/x-www-form-urlencoded
        $fileUploadResult = Invoke-WebRequest -Uri $hookurl -Method Post -Form @{file1 = Get-Item -Path $file } -ContentType 'multipart/form-data'

        if ($fileUploadResult.StatusCode -eq 200) {
            Write-Host "File upload successful!" -ForegroundColor Green
        }
        else {
            Write-Host "File upload failed!" -ForegroundColor Red
        }
    }
}

# Initialize
#New-DiscordFileUpload -file "C:\ProgramData\Remove-AdobeFlashPlayer.log" -text "Adobe Flash Player has been removed from $env:computername."

Write-Host "[ New-DiscordFileUpload ]"
Write-Host "Initializing script..."
$userFilePath = Read-Host -Prompt "Enter the path to the file you want to upload to Discord"
$userText = Read-Host -Prompt "Enter the description or any additional text you want to include with the file upload"

# Run the function
Write-Host "Uploading file to Discord, please wait... "
New-DiscordFileUpload -file $userFilePath -text $userText
Write-Host "Upload complete!" -ForegroundColor Green

# End
Read-Host -Prompt "Press Enter to exit"
