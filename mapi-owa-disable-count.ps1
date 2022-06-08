$StopWatch = [System.Diagnostics.Stopwatch]::StartNew()
Write-Output "Start time: $(Get-Date)"
Write-Output ""

$Mailboxes = Get-Content ".\mapi-disablement.csv" -TotalCount 30

$BothCount = 0
$OWAOnlyCount = 0
$ImapOnlyCount = 0
$NoImapOrOWASet = 0
$IdentityErrors = 0

$Mailboxes | ForEach-Object {
    try {
        $UserInfo =  Get-CASMailbox -Identity  $_ -ErrorAction Continue

        if($UserInfo.MAPIEnabled.ToString() -eq "False" -and $UserInfo.OWAEnabled.ToString() -eq "False") {
            $BothCount++
        }
        elseif ($UserInfo.MAPIEnabled.ToString() -eq "True" -and $UserInfo.OWAEnabled.ToString() -eq "False") {
            $OWAOnlyCount++
        }
        elseif ($UserInfo.MAPIEnabled.ToString() -eq "False" -and $UserInfo.OWAEnabled.ToString() -eq "True") {
            $ImapOnlyCount++
        }
        else {
            $NoImapOrOWASet++
        }

        $UserInfo | Format-List Identity,MAPIEnabled,OWAEnabled >> '.\mapi-owa-disable-table.csv'
    }

    catch {
        $_.ErrorDetails | Out-File -Append '.\disable_count.log' -NoClobber
        $IdentityErrors++
    }
}

Write-Output "Number of User with both Attributes Set: $BothCount"
Write-Output "Number of Users with only OWA Set: $OWAOnlyCount"
Write-Output "Number of Users with only Mapi Set: $ImapOnlyCount"
Write-Output "Number of Users with neither set: $NoImapOrOWASet"
Write-Output "Number of Identity Issues: $IdentityErrors"

Write-Output ""
Write-Output "Time Elapsed: " $StopWatch.Elapsed.TotalMinutes