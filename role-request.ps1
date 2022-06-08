$Roles = @(
"41a54ebb-8765-4a83-98df-65e6de89e4c1", # Exchange Admin
"571d709f-7be3-4b1b-b20e-b81d28599d58", # PRA
"8f261132-432c-4613-b6e2-2f8b74e941f1", # Security Admin
"ee0fc937-378f-40ce-8fae-60d37eb77133", # PAA
"e889d432-ce39-45b1-9b8e-b524666e251c"
)

$Schedule = New-Object Microsoft.Open.MSGraph.Model.AzureADMSPrivilegedSchedule
$Schedule.Type = "Once"
$Schedule.StartDateTime = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ss.fffz")
$Schedule.endDateTime = 

foreach($role in $Roles){
	Open-AzureADMSPrivilegedRoleAssignmentRequest -ProviderId 'aadRoles' -
}