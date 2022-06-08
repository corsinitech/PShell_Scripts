# Allows for modules not signed by your PC
Set-ExecutionPolicy RemoteSigned -Verbose -Confirm: $false

#Install AzureAD module
Install-Module AzureAD -Verbose -Confirm: $false

#Install Exchange Management Module
Install-Module ExchangeOnlineManagement -Verbose -Confirm: $false

#Install Sharepoint Powershell Module
Install-Module Microsoft.Online.Sharepoint.Powershell -Verbose -Confirm: $false

#Install Module for Orca
Install-Module Orca -Verbose -Confirm: $false

#Set Authentication Client
Set-Variable winrm/config/client/auth@{Basic="True"} -Verbose 
