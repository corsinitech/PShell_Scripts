# USNavyCloud42 Login
Connect-ExchangeOnline -UserPrincipalName gabriel.corsini.admin@usnavycloud42.onmicrosoft.us -ConnectionUri https://outlook.office365.us/powershell-liveid -AzureADAuthorizationEndPointUri https://login.microsoftonline.us/common

#Flankspeed Login
Connect-ExchangeOnline -UserPrincipalName gabriel.corsini.admin@flankspeed.onmicrosoft.us -ConnectionUri https://webmail.apps.mil/powershell-liveid -AzureADAuthorizationEndPointUri https://login.microsoftonline.us/common

# Cloud42 IPPSSession Login for Security Things
Connect-IPPSSession -UserPrincipalName gabriel.corsini.admin@usnavycloud42.onmicrosoft.us -ConnectionUri https://l5.ps.compliance.protection.office365.us/powershell-liveid/ -AzureADAuthorizationEndPointUri https://login.microsoftonline.us/common 

# Flankspeed IPPSSession login
Connect-IPPSSession -UserPrincipalName gabriel.corsini.admin@flankspeed.onmicrosoft.us -ConnectionUri https://webmail.apps.mil/powershell-liveid -AzureADAuthorizationEndPointUri https://login.microsoftonline.us/common 

Connect-EXOPSSession -UserPrincipalName gabriel.corsini.admin@flankspeed.onmicrosoft.us -WarningAction SilentlyContinue -AzureADAuthorizationEndpointUri https://login.microsoftonline.us/common -ConnectionUri https://webmail.apps.mil/powershell-liveid/

Connect-AzAccount -UserPrincipalName gabriel.corsini.admin@flankspeed.onmicrosoft.us -ConnectionUri https://webmail.apps.mil/powershell-liveid -AzureADAuthorizationEndPointUri https://login.microsoftonline.us/common
