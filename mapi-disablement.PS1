$StopWatch = [System.Diagnostics.Stopwatch]::StartNew()
Write-Output "Start time: $(Get-Date)"
Write-Output ""

$MapiCSV = Get-Content ".\mapi-disablement.csv"

$MapiCSV | ForEach-Object {
    Set-CASMailbox -Identity $_ -MAPIEnabled $false -OWAEnabled $false
}

Write-Output ""
Write-Output "Time Elapsed: " $StopWatch.Elapsed.TotalMinutes