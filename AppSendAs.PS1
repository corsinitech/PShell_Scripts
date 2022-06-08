#Allows the app to send as a User
New-ApplicationAccessPolicy -AppId [enter App ID here] -PolicyScopeGroupId [enter group ID here] -AccessRight RestrictAccess -Description "Restrict this app to members of distribution group EvenUsers."
