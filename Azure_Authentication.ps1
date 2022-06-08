# USNavyCloud42 Login
Connect-ExchangeOnline -UserPrincipalName [enter admin upn here] -ConnectionUri https://outlook.office365.us/powershell-liveid -AzureADAuthorizationEndPointUri https://login.microsoftonline.us/common

#Flankspeed Login
Connect-ExchangeOnline -UserPrincipalName [enter admin upn here] -ConnectionUri https://webmail.apps.mil/powershell-liveid -AzureADAuthorizationEndPointUri https://login.microsoftonline.us/common

# Cloud42 IPPSSession Login for Security Things
Connect-IPPSSession -UserPrincipalName [enter admin upn here] -ConnectionUri https://l5.ps.compliance.protection.office365.us/powershell-liveid/ -AzureADAuthorizationEndPointUri https://login.microsoftonline.us/common 

# Flankspeed IPPSSession login
Connect-IPPSSession -UserPrincipalName [enter admin upn here] -ConnectionUri https://webmail.apps.mil/powershell-liveid -AzureADAuthorizationEndPointUri https://login.microsoftonline.us/common 

Connect-EXOPSSession -UserPrincipalName [enter admin upn here] -WarningAction SilentlyContinue -AzureADAuthorizationEndpointUri https://login.microsoftonline.us/common -ConnectionUri https://webmail.apps.mil/powershell-liveid/

Connect-AzAccount -UserPrincipalName [enter admin upn here] -ConnectionUri https://webmail.apps.mil/powershell-liveid -AzureADAuthorizationEndPointUri https://login.microsoftonline.us/common
