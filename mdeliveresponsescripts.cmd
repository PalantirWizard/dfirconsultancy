# Collect Running Processes Information
Get-Process | Select-Object Name, Id, Path, CPU, StartTime | Export-Csv -Path "C:\Windows\Temp\RunningProcesses.csv" -NoTypeInformation
Write-Output "Running processes information saved to C:\Windows\Temp\RunningProcesses.csv"


# List All Established Network Connections
Get-NetTCPConnection -State Established | Select-Object LocalAddress, LocalPort, RemoteAddress, RemotePort, State | Out-File -FilePath "C:\Windows\Temp\EstablishedConnections.txt"
Write-Output "Established network connections saved to C:\Windows\Temp\EstablishedConnections.txt"


# Check for Suspicious Autorun Entries
$autorunKeys = @(
    "HKLM:\Software\Microsoft\Windows\CurrentVersion\Run",
    "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run",
    "HKLM:\Software\Microsoft\Windows\CurrentVersion\RunOnce",
    "HKCU:\Software\Microsoft\Windows\CurrentVersion\RunOnce"
)

$autorunEntries = foreach ($key in $autorunKeys) {
    Get-ItemProperty -Path $key | Select-Object PSChildName, Property, Value
}

$autorunEntries | Out-File -FilePath "C:\Windows\Temp\AutorunEntries.txt"
Write-Output "Suspicious autorun entries saved to C:\Windows\Temp\AutorunEntries.txt"


# Clear Windows Event Logs
wevtutil cl Security
wevtutil cl System
wevtutil cl Application

Write-Output "Windows Event Logs (Security, System, Application) have been cleared."


# Search for Files by Extension and Date Range
$path = "C:\"
$extension = "*.exe"
$dateRange = (Get-Date).AddDays(-7)

Get-ChildItem -Path $path -Recurse -Include $extension | Where-Object { $_.LastWriteTime -ge $dateRange } | Select-Object FullName, LastWriteTime | Export-Csv -Path "C:\Windows\Temp\RecentFiles.csv" -NoTypeInformation
Write-Output "Files with extension $extension modified in the last 7 days have been saved to C:\Windows\Temp\RecentFiles.csv"


