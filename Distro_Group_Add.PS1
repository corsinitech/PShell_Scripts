$StopWatch = [System.Diagnostics.Stopwatch]::StartNew()
Write-Output "Start time: $(Get-Date)"
Write-Output ""

$Contacts = Get-Content .\Exported_Mail_Contacts.csv -TotalCount 10000

$Contacts | ForEach-Object {
    Add-DistributionGroupMember -Identity "Flank Speed Group 1" -Member "$_"
}

Write-Output ""
Write-Output "Time Elapsed: " $StopWatch.Elapsed.TotalMinutes