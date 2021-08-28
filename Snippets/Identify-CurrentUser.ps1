# Runs the 'whoami' command and stores the output in the C:\Users\Public directory (so, regardless of permissions, you can write there.)
# Useful if you're trying to determine what context your script is running in or why a script isn't running correctly
$filePath = "C:\Users\Public\Who-Am-I.txt"
$thisUser = whoami
$resultStr = "Currently running as: $thisUser"
Write-Host $resultStr
Set-Content -Path $filePath -Value $resultStr -Force
