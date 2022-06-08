$StopWatch = [System.Diagnostics.Stopwatch]::StartNew()
Write-Output "Start time: $(Get-Date)"
Write-Output ""

#Disable Mapi
#Use samde CSV with UPN for all Variables


Write-Output "Disabling MAPI and OWA..."

$MapiCSV = Get-Content ".\ExchangeCleanup.csv"

$MapiCSV | ForEach-Object {
    $MapiBefore =  Get-CASMailbox -Identity  $_ -ErrorAction Continue
    Write-Output "BEFORE" >> '.\mapi-owa-disable-before.csv'
    $MapiBefore | Format-List Identity,MAPIEnabled,OWAenabled >> '.\mapi-owa-disable-before.csv'
    
    Set-CASMailbox -Identity $_ -MAPIEnabled $false -OWAEnabled $false

    $MapiAfter = Get-CASMailbox -Identity  $_ -ErrorAction Continue
    Write-Output "AFTER" >> '.\mapi-owa-disable-before.csv'
    $MapiAfter | Format-List Identity,MAPIEnabled,OWAenabled >> '.\mapi-owa-disable-before.csv'
}


$Mailboxes = Get-Content ".\ExchangeCleanup.csv"

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

#Disable Exchange Powershell

Write-Output "Disabling Exchange Remote Powershell..."

$NPS = Get-Content ".\ExchangeCleanup.csv"
$NPS | ForEach-Object {
    Write-Output "BEFORE" >> '.\PS-disable-before.csv'
    get-user -Identity $_ | FL Identity,RemotePowerShellEnabled >> ".\PS-disable-before.csv"

    Set-User -Identity $_ -RemotePowerShellEnabled $false

    Write-Output "AFTER" >> '.\PS-disable-before.csv'
    get-user -Identity $_ | FL Identity,RemotePowerShellEnabled >> ".\PS-disable-before.csv"
}


Write-Output "Complete!"
Write-Output ""
Write-Output "Time Elapsed: " $StopWatch.Elapsed.TotalMinutes