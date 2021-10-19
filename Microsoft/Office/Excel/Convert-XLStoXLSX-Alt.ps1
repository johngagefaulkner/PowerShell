<#
    - Name: Convert-XlsToXlsx.ps1
    - Description: Creates a shortcut and places it on the desktop of either a specified user or all users.
    - Author: PowerShell.One
    - Last Updated: April 23, 2020
    - Reference Guide: https://powershell.one/tricks/parsing/excel#converting-xls-to-xlsx
#>
Clear-Host

# Define Variables
$logOutputDir = "^$logOutputDir^"
$sourceDir = "^$sourceDir^"
$targetDir = "^$targetDir^"

Start-Transcript -OutputDirectory $logOutputDir -Append -Force -IncludeInvocationHeader
Write-Host "[Convert-XlsToXlsx]"

# Display running script context
$scriptRunningUnder = whoami
Write-Host "Script running as: $scriptRunningUnder"

function Convert-XlsToXlsx
{
  param
  (
    # Path to the xls file to convert:
    [Parameter(Mandatory,ValueFromPipeline,ValueFromPipelineByPropertyName)]
    [string[]]
    [Alias('FullName')]
    $Path,

    [Parameter()]
    [string]
    [Alias('OutputDirectory')]
    $OutputDirPath,

    # overwrite file if it exists:
    [switch]
    $Force,
    
    # show excel window during conversion. This can be useful for diagnosis and debugging.
    [switch]
    $Visible
  )

  # do this before any file can be processed:
  begin
  {
    # load excel assembly (requires excel to be installed)
    Add-Type -AssemblyName Microsoft.Office.Interop.Excel

    # open excel in a hidden window
    $excel = New-Object -ComObject Excel.Application
    $workbooks = $excel.Workbooks
    if ($Visible) { $excel.Visible = $true }

    # disable interactive dialogs
    $excel.DisplayAlerts = $False
    $excel.WarnOnFunctionNameConflict = $False
    $excel.AskToUpdateLinks = $False

    # target file formats
    $xlsx = [Microsoft.Office.Interop.Excel.XlFileFormat]::xlOpenXMLWorkbook
    $xlsm = [Microsoft.Office.Interop.Excel.XlFileFormat]::xlOpenXMLWorkbookMacroEnabled
  }

  # do this for each file:
  process
  {
    foreach($_ in $Path)
    {
      # check for valid file extension:
      $extension = [System.Io.Path]::GetExtension($_)
      if ($extension -ne '.xls') 
      { 
        Write-Host "[MSG],Warning,Skipped,File Extension not .XLS, $_" -ForegroundColor Yellow
        continue 
      } 
  
      # open file in excel:
      $workbook = $workbooks.Open($_)
      
      # test for macros:
      if ($workbook.HasVBProject)
      {
        $extension = 'xlsm'
        $type = $xlsm
      }
      else
      {
        $extension = 'xlsx'
        $type = $xlsx      
      }
      
       # get destination path
      #$outputFilePath = [System.Io.Path]::ChangeExtension($_, $extension)
      $tmpName = [System.IO.Path]::GetFileNameWithoutExtension($_)
      $outputName = $tmpName+"."+$extension
      $outputFilePath = Join-Path -Path $OutputDirPath -ChildPath $outputName

      # does it exist?
      $exists = (Test-Path -Path $outputFilePath) -and !$Force
      if ($exists)
      {
        Write-Host "[MSG],Warning,Skipped,File exists and -Force was not specified, $_" -ForegroundColor Yellow
        continue
      }
      
      # save in new format:
      $workbook.SaveAs($outputFilePath, $type)
      # close document
      $workbook.Close()
      # release COM objects to prevent memory leaks:
      $null = [System.Runtime.InteropServices.Marshal]::ReleaseComObject($workbook)
      
      #Write-Host "[Success] '$_' -> '$outputFilePath'" -ForegroundColor Green
      Write-Host "[MSG],Success,Converted, , '$_'" -ForegroundColor Green
    }
  }
  
  # do this once all files have been processed
  end
  {
    # quit excel and clean up:
    $excel.Quit()
    
    # release COM objects to prevent memory leaks:
    $null = [System.Runtime.InteropServices.Marshal]::ReleaseComObject($workbooks)
    $null = [System.Runtime.InteropServices.Marshal]::ReleaseComObject($excel)
    $excel = $workbooks = $null
    # clean up:
    [GC]::Collect()
    [GC]::WaitForPendingFinalizers()
    Write-Host "Done! Operation completed successfully!"
  }
}

Write-Host " "

# Path to folder containing .XLS Excel (97-2003) files.
# $userDir = Read-Host -Prompt "Please Enter Full Path to Folder Containing .XLS Files"
# Write-Host "Obtaining a list of files requiring conversion, please wait... "

# get all xls files and convert them:
Get-ChildItem -Path $sourceDir -Filter *.xls -File -Force -Recurse | Convert-XlsToXlsx -Force -OutputDirectory $targetDir

# Get list of all files matching extension filter, return some properties and convert to JSON
# Get-ChildItem -Path $userDir -Filter *.xls -Recurse -Force |Select-Object Name,Length,IsReadOnly,Exists,FullName,Extension -ExcludeProperty "CIM*" |ConvertTo-Json -Compress |Out-File -FilePath "C:\Users\Public\List_of_old_Excel_Files.json" -Force

Stop-Transcript
