$testURL = "[url to Test API]"
$prodURL = "[url to Prod API]"
$testApiKey = "[Test API Key]"
$prodApiKey = "[Prod API Key]"
$testThumbprint = "[test certificate thumbprint]"
$prodThumbprint = "[Prod certificate thumbprint]"
$certStore = "Cert:\CurrentUser\My"
$requestHeaders = @{
	'accept'='*/*'
	'Ocp-Apim-Subscription-Key' = ''
}
$CustomerCode = [enter customer code here]
$readAllCustomerCode = [read all customer code here]

Function Check-DepoApiConnection {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$true, HelpMessage="Enter 'test' or 'prod' to check the connectivity to the appropriate API endpoint")]$api,
        [Parameter(Mandatory=$true, HelpMessage="Enter 'Get' or 'Post' to check the connectivity to the appropriate API endpoint")]$method

    )
    $apiInput = $api
    $methodInput = $method

    switch($apiInput.toLower()){

        "test" {
            $certificate = gci $certStore | Where-Object {$_.Thumbprint -eq $testThumbprint}
            $requestHeaders.'Ocp-Apim-Subscription-Key' = $testApiKey

            $fullURL = $testURL + "/ping"

            try {
                Invoke-WebRequest -Uri $fullURL -Method $methodInput -ContentType "application/json" -Headers $requestHeaders -Certificate $certificate
            } catch {
                Write-Host "Statuscode: " $_.Exception.Response.StatusCode
                Write-Host "StatusDescription: " $_.Exception.Message
                $streamReader = [System.IO.StreamReader]::new($_.Exception.Response.GetResponseStream())
                $ErrResp = $streamReader.ReadToEnd() | ConvertFrom-Json
                $streamReader.Close()
            }

            $ErrResp
        }

        Default {
            $certificate = gci -Path $certStore | Where-Object {$_.Thumbprint -eq $prodThumbprint}
            $requestHeaders.'Ocp-Apim-Subscription-Key' = $prodApiKey

            $fullURL = $prodURL + "/ping"

            try {
                Invoke-WebRequest -Uri $fullURL -Method $methodInput -ContentType "application/json" -Headers $requestHeaders -Certificate $certificate
            } catch {
                Write-Host "Statuscode: " $_.Exception.Response.StatusCode
                Write-Host "StatusDescription: " $_.Exception.Message
                $streamReader = [System.IO.StreamReader]::new($_.Exception.Response.GetResponseStream())
                $ErrResp = $streamReader.ReadToEnd() | ConvertFrom-Json
                $streamReader.Close()
            }

            $ErrResp
        }
    }       
}

Function Get-DepoUser {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$true, HelpMessage="Enter the 10 digit DODID or EDIPI.PTC of the user you want to find within DEPO")]
		[string]$edipi,
		[Parameter(Mandatory=$false, HelpMessage="Enter 'test' or 'prod' to check the connectivity to the appropriate API endpoint")]
		[string]$api
	)
	
	$dodid = $edipi
	$apiInput = $api
	
	switch($apiInput.toLower()){
		"test" {
			$fullURL = $testUrl + "/dee-o365/Persona/" + $readAllCustomerCode + "/" + $dodid
			$requestHeaders.'Ocp-Apim-Subscription-Key' = $testApiKey
			$certificate = gci $certStore | Where-Object {$_.Thumbprint -eq $testThumbprint}
			try {
                Invoke-RestMethod -Uri $fullURl -Method Get -ContentType "application/json" -Headers $requestHeaders -Certificate $certificate
			} catch {
                Write-Host "Statuscode: " $_.Exception.Response.StatusCode
                Write-Host "StatusDescription: " $_.Exception.Message
                $streamReader = [System.IO.StreamReader]::new($_.Exception.Response.GetResponseStream())
                $ErrResp = $streamReader.ReadToEnd() | ConvertFrom-Json
                $streamReader.Close()
            }

            $ErrResp
		}
		Default {
			$fullURL = $prodURL + "/dee-o365/Persona/" + $readAllCustomerCode + "/" + $dodid
			$requestHeaders.'Ocp-Apim-Subscription-Key' = $prodApiKey
			$certificate = gci -Path $certStore | Where-Object {$_.Thumbprint -eq $prodThumbprint}
			try {
                Invoke-RestMethod -Uri $fullURl -Method Get -ContentType "application/json" -Headers $requestHeaders -Certificate $certificate
			} catch {
                Write-Host "Statuscode: " $_.Exception.Response.StatusCode
                Write-Host "StatusDescription: " $_.Exception.Message
                $streamReader = [System.IO.StreamReader]::new($_.Exception.Response.GetResponseStream())
                $ErrResp = $streamReader.ReadToEnd() | ConvertFrom-Json
                $streamReader.Close()
            }

            $ErrResp
		}
	}
}

Function Get-DepoUserDetails {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$true, HelpMessage="Enter the 10 digit DODID or EDIPI.PTC of the user you want to find within DEPO")]
		[string]$edipi,
		[Parameter(Mandatory=$false, HelpMessage="Enter 'test' or 'prod' to check the connectivity to the appropriate API endpoint")]
		[string]$api
	)
	
	$dodid = $edipi
	$apiInput = $api
	
	switch($apiInput.toLower()){

		"test" {
			$requestHeaders.'Ocp-Apim-Subscription-Key' = $testApiKey
			$certificate = gci $certStore | Where-Object {$_.Thumbprint -eq $testThumbprint}

			$personaURL = $testUrl + "/dee-o365/Persona/" + $readAllCustomerCode + "/" + $dodid
			$response = Invoke-RestMethod -Uri $personaURL -Method Get -ContentType "application/json" -Headers $requestHeaders -Certificate $certificate
			$personaId = $response.personaId

			$personaDetailURL = $testURL + "/dee-o365/Persona/GetPersonaDetails/" + $personaId

			try {
                Invoke-RestMethod -Uri $personaDetailURL -Method Get -ContentType "application/json" -Headers $requestHeaders -Certificate $certificate | fl displayName, edipi, personaId, email, isPivAuth, accountStatus, customerCode
                
            } catch {
                Write-Host "Statuscode: " $_.Exception.Response.StatusCode
                Write-Host "StatusDescription: " $_.Exception.Message
                $streamReader = [System.IO.StreamReader]::new($_.Exception.Response.GetResponseStream())
                $ErrResp = $streamReader.ReadToEnd() | ConvertFrom-Json
                $streamReader.Close()
            }

            $ErrResp
        }

		Default {
			$requestHeaders.'Ocp-Apim-Subscription-Key' = $prodApiKey
			$certificate = gci -Path $certStore | Where-Object {$_.Thumbprint -eq $prodThumbprint}

			$personaURL = $prodURL + "/dee-o365/Persona/" + $readAllCustomerCode + "/" + $dodid
			$response = Invoke-RestMethod -Uri $personaURL -Method Get -ContentType "application/json" -Headers $requestHeaders -Certificate $certificate
			$personaId = $response.personaId

			$personaDetailURL = $prodURL + "/dee-o365/Persona/GetPersonaDetails/" + $personaId

			try {
                Invoke-RestMethod -Uri $personaDetailURL -Method Get -ContentType "application/json" -Headers $requestHeaders -Certificate $certificate | fl displayName, edipi, personaId, email, isPivAuth, accountStatus, customerCode
            } catch {
                Write-Host "Statuscode: " $_.Exception.Response.StatusCode
                Write-Host "StatusDescription: " $_.Exception.Message
                $streamReader = [System.IO.StreamReader]::new($_.Exception.Response.GetResponseStream())
                $ErrResp = $streamReader.ReadToEnd() | ConvertFrom-Json
                $streamReader.Close()
            }

            $ErrResp
		}
	}
}

Function Get-DepoUserEntitlement {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true, HelpMessage="Enter the 10 digit DODID or EDIPI.PTC of the user you want to find within DEPO")]
		[string]$edipi,
		[Parameter(Mandatory=$false, HelpMessage="Enter 'test' or 'prod' to check the connectivity to the appropriate API endpoint")]
		[string]$api
    )
    $dodid = $edipi
    $apiInput = $api

    switch($apiInput.toLower()){

		"test" {
			$requestHeaders.'Ocp-Apim-Subscription-Key' = $testApiKey
			$certificate = gci $certStore | Where-Object {$_.Thumbprint -eq $testThumbprint}

			$personaURL = $testUrl + "/dee-o365/Persona/" + $readAllCustomerCode + "/" + $dodid
			$response = Invoke-RestMethod -Uri $personaURL -Method Get -ContentType "application/json" -Headers $requestHeaders -Certificate $certificate
			$personaId = $response.personaId

            $personaDetailURL = $testURL + "/dee-o365/Persona/GetPersonaDetails/" + $personaId
			$detailedResponse = Invoke-RestMethod -Uri $personaDetailURL -Method Get -ContentType "application/json" -Headers $requestHeaders -Certificate $certificate
            $customerId = $detailedResponse.customerId

			$entitlementURL = $testURL + "/O365PersonaEntitlement/" + $personaId + "/" + $customerId

            try {
                Invoke-RestMethod -Uri $entitlementURL -Method Get -ContentType "application/json" -Headers $requestHeaders -Certificate $certificate | fl personaId, entitlementName, entitlementType, hasEntitlement
            } catch {
                Write-Host "Statuscode: " $_.Exception.Response.StatusCode
                Write-Host "StatusDescription: " $_.Exception.Message
                $streamReader = [System.IO.StreamReader]::new($_.Exception.Response.GetResponseStream())
                $ErrResp = $streamReader.ReadToEnd() | ConvertFrom-Json
                $streamReader.Close()
            }

            $ErrResp
		}

		Default {
			$requestHeaders.'Ocp-Apim-Subscription-Key' = $prodApiKey
			$certificate = gci -Path $certStore | Where-Object {$_.Thumbprint -eq $prodThumbprint}

			$personaURL = $prodURL + "/dee-o365/Persona/" + $readAllCustomerCode + "/" + $dodid
			$response = Invoke-RestMethod -Uri $personaURL -Method Get -ContentType "application/json" -Headers $requestHeaders -Certificate $certificate
			$personaId = $response.personaId

			$personaDetailURL = $prodURL + "/dee-o365/Persona/GetPersonaDetails/" + $personaId
			$detailedResponse = Invoke-RestMethod -Uri $personaDetailURL -Method Get -ContentType "application/json" -Headers $requestHeaders -Certificate $certificate
            $customerId = $detailedResponse.customerId

			$entitlementURL = $prodURL + "/O365PersonaEntitlement/" + $personaId + "/" + $customerId

            try {
                Invoke-RestMethod -Uri $entitlementURL -Method Get -ContentType "application/json" -Headers $requestHeaders -Certificate $certificate | fl personaId, entitlementName, entitlementType, hasEntitlement
            } catch {
                Write-Host "Statuscode: " $_.Exception.Response.StatusCode
                Write-Host "StatusDescription: " $_.Exception.Message
                $streamReader = [System.IO.StreamReader]::new($_.Exception.Response.GetResponseStream())
                $ErrResp = $streamReader.ReadToEnd() | ConvertFrom-Json
                $streamReader.Close()
            }

            $ErrResp
		}
	}
}

Function Deprovision-DepoUser {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true, HelpMessage="Enter the 10 digit DODID or EDIPI.PTC of the user you want to find within DEPO")]
		[string]$edipi,
		[Parameter(Mandatory=$false, HelpMessage="Enter 'test' or 'prod' to check the connectivity to the appropriate API endpoint")]
		[string]$api
    )
    $dodid = $edipi
    $apiInput = $api

    switch($apiInput.toLower()){

		"test" {
			$requestHeaders.'Ocp-Apim-Subscription-Key' = $testApiKey
			$certificate = gci $certStore | Where-Object {$_.Thumbprint -eq $testThumbprint}

			$personaURL = $testUrl + "/dee-o365/Persona/" + $readAllCustomerCode + "/" + $dodid
			$response = Invoke-RestMethod -Uri $personaURL -Method Get -ContentType "application/json" -Headers $requestHeaders -Certificate $certificate | Write-Output
			$personaId = $response.personaId

            $entitlementIdUrl = $testUrl + "/O365PersonaEntitlement/" + $personaId + "/" + $navyCustomerCode
            $response = Invoke-RestMethod -Uri $entitlementIdUrl -Method Get -ContentType "application/json" -Headers $requestHeaders -Certificate $certificate | Write-Output
            $entitlementId = $response.entitlementId

            $body = @"
                {
                    "customerId": $($navyCustomerCode),
                    "o365PersonaEntitlements": [
                        {
                            "personaId": $($personaId),
                            "entitlementId": $($entitlementId),
                            "hasEntitlement": false
                        }
                    ]
                }

"@
			$deprovisionURL = $testUrl + "/O365PersonaEntitlement"
            try {
                Invoke-RestMethod -Uri $deprovisionURL -Method Post -ContentType "application/json" -Headers $requestHeaders -Certificate $certificate -Body $body | fl
            } catch {
                Write-Host "Statuscode: " $_.Exception.Response.StatusCode
                Write-Host "StatusDescription: " $_.Exception.Message
                $streamReader = [System.IO.StreamReader]::new($_.Exception.Response.GetResponseStream())
                $ErrResp = $streamReader.ReadToEnd() | ConvertFrom-Json
                $streamReader.Close()
            }

            $ErrResp
		}

		Default {
			$requestHeaders.'Ocp-Apim-Subscription-Key' = $prodApiKey
			$certificate = gci -Path $certStore | Where-Object {$_.Thumbprint -eq $prodThumbprint}

			$personaURL = $prodURL + "/dee-o365/Persona/" + $navyCustomerCode + "/" + $dodid
			$response = Invoke-RestMethod -Uri $personaURL -Method Get -ContentType "application/json" -Headers $requestHeaders -Certificate $certificate
			$personaId = $response.personaId

            $entitlementURL = $prodURL + "/O365PersonaEntitlement/" + $personaId + "/" + $navyCustomerCode
            $response = Invoke-RestMethod -Uri $entitlementURL -Method Get -ContentType "application/json" -Headers $requestHeaders -Certificate $certificate
            $entitlementId = $response.entitlementId

            $body = @"
                {
                    "customerId": $($navyCustomerCode),
                    "o365PersonaEntitlements": [
                        {
                            "personaId": $($personaId),
                            "entitlementId": $($entitlementId),
                            "hasEntitlement": false
                        }
                    ]
                }

"@

			$deprovisionURL = $prodURL + "/O365PersonaEntitlement"
            try {
                Invoke-RestMethod -Uri $deprovisionURL -Method Post -ContentType "application/json" -Headers $requestHeaders -Certificate $certificate -body $body | fl
            } catch {
                Write-Host "Statuscode: " + $_.Exception.Response.StatusCode
                Write-Host "StatusDescription: " + $_.Exception.Message
                $streamReader = [System.IO.StreamReader]::new($_.Exception.Response.GetResponseStream())
                $ErrResp = $streamReader.ReadToEnd() | ConvertFrom-Json
                $streamReader.Close()
            }
		}
	}
}

Function Provision-DepoUser {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true, HelpMessage="Enter the 10 digit DODID or EDIPI.PTC of the user you want to find within DEPO")]
		[string]$edipi,
		[Parameter(Mandatory=$false, HelpMessage="Enter 'test' or 'prod' to check the connectivity to the appropriate API endpoint")]
		[string]$api
    )
    $dodid = $edipi
    $apiInput = $api

    switch($apiInput.toLower()){
		"test" {
			$requestHeaders.'Ocp-Apim-Subscription-Key' = $testApiKey
			$certificate = gci $certStore | Where-Object {$_.Thumbprint -eq $testThumbprint}
			$personaURL = $testUrl + "/dee-o365/Persona/" + $navyCustomerCode + "/" + $dodid
			$response = Invoke-RestMethod -Uri $personaURL -Method Get -ContentType "application/json" -Headers $requestHeaders -Certificate $certificate
			$personaId = $response.personaId

            $body = @"
                {
                    "customerId": $($navyCustomerCode),
                    "o365PersonaEntitlements": [
                        {
                            "personaId": $($personaId),
                            "entitlementId": 58,
                            "hasEntitlement": true
                        }
                    ]
                }

"@

			$provisionURL = $testUrl + "/O365PersonaEntitlement"

            try {
                Invoke-RestMethod -Uri $provisionURL -Method Post -ContentType "application/json" -Headers $requestHeaders -Certificate $certificate -Body $body
            } catch {
                Write-Host "Statuscode: " $_.Exception.Response.StatusCode
                Write-Host "StatusDescription: " $_.Exception.Message
                $streamReader = [System.IO.StreamReader]::new($_.Exception.Response.GetResponseStream())
                $ErrResp = $streamReader.ReadToEnd() | ConvertFrom-Json
                $streamReader.Close()
            }
            $ErrResp
		}
		Default {
			$requestHeaders.'Ocp-Apim-Subscription-Key' = $prodApiKey
			$certificate = gci -Path $certStore | Where-Object {$_.Thumbprint -eq $prodThumbprint}

			$personaURL = $prodURL + "/dee-o365/Persona/" + $navyCustomerCode + "/" + $dodid
			$response = Invoke-RestMethod -Uri $personaURL -Method Get -ContentType "application/json" -Headers $requestHeaders -Certificate $certificate
			$personaId = $response.personaId

            $body = @"
                {
                    "customerId": $($navyCustomerCode),
                    "o365PersonaEntitlements": [
                        {
                            "personaId": $($personaId),
                            "entitlementId": 58,
                            "hasEntitlement": true
                        }
                    ]
                }

"@

			$provisionURL = $prodURL + "/O365PersonaEntitlement"

            try {
                Invoke-RestMethod -Uri $provisionURL -Method Post -ContentType "application/json" -Headers $requestHeaders -Certificate $certificate -body $body
            } catch {
                Write-Host "Statuscode: " + $_.Exception.Response.StatusCode
                Write-Host "StatusDescription: " + $_.Exception.Message
                $streamReader = [System.IO.StreamReader]::new($_.Exception.Response.GetResponseStream())
                $ErrResp = $streamReader.ReadToEnd() | ConvertFrom-Json
                $streamReader.Close()
            }
            $ErrResp
		}
	}
}


