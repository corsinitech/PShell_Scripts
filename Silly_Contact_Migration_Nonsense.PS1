$StopWatch = [System.Diagnostics.Stopwatch]::StartNew()
Write-Output "Start time: $(Get-Date)"
Write-Output ""

Import-Csv .\batch_4.csv | ForEach-Object {
    New-MailContact -Name $_.Name -DisplayName $_.Name -ExternalEmailAddress $_.ExternalEmailAddress -FirstName $_.FirstName -LastName $_.LastName | Out-File -FilePath.\Batch4Results.txt -Append
}

Write-Output ""
Write-Output "Time Elapsed: " $StopWatch.Elapsed.TotalMinutes