$list = Import-Csv './exportUser.csv'
$count = 0

 

for ($i=0; $i -le $list.length; $i++) {
    $upn = $list[$i].userPrincipalName
    $count++
    echo "Accounts found: $count"
    try {
        $user = Get-AzureADUserExtension -ObjectId $upn
        $list[$i].EDIPI = $user.employeeId
    }
    catch {
        $list[$i].EDIPI = 'SAD'
    }
    Start-Sleep -Milliseconds 10
}

 

$list | Export-Csv -path "./new_list.csv"