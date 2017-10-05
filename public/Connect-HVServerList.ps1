function Connect-HvServerList{
    [cmdletbinding(DefaultParameterSetName="ServerHash")]
    param(
        [Parameter(ParameterSetName="ServerHash")]
        $ServerHash = $Script:Config.Servers,
        [Parameter(ParameterSetName="Server")]
        [string]$Server,
        [Parameter(ParameterSetName="UseExisting")]
        [Switch]$UseExisting,
        [Parameter(dontshow)]
        $CredentialFile = $Script:Config.CredentialFile
    )
    $ParameterSet = $PSCmdlet.ParameterSetName
    if ($ParameterSet -eq "ServerHash" -and $ServerHash -eq $null){
        $ParameterSet = "ExistingConnections"
    }

    If ($Script:Config.CredentialFile -ne $null){
        $Credential = Import-Clixml -Path $CredentialFile -ErrorAction Stop
    }
    Else {
        $Credential = Get-Credential -Message "Please enter your credentials to connect to your Horizon Servers"
    }

    Switch($ParameterSet){
        "ServerHash"{
            foreach ($ServerEntry in $ServerHash.GetEnumerator()){
                $Connection = Connect-HVServer -Server $ServerEntry.value -Credential $Credential
                If ($Script:Config.ApiList.Keys -notcontains $ServerEntry.Key){
                    $script:Config.ApiList.Add($ServerEntry.Key,$Connection.ExtensionData)
                }
                else{
                    $Script:Config.ApiList[$ServerEntry.Key] = $Connection.ExtensionData
                }
            }
        }
        "Server"{
            $Connection = Connect-HVServer -Server $Server -Credential $Credential
            $Script:Config.ApiList.Add($Server,$Connection.ExtensionData)
            Set-CurrentHvServer -Server $Server
        }
        "UseExisting"{
            Foreach ($ServerEntry in $global:DefaultHVServers){
                $Connection = $ServerEntry
                $Script:Config.ApiList.Add($ServerEntry.Name,$Connection.ExtensionData)
            }
            Set-CurrentHvServer -Server $global:DefaultHvServers[0].Name
        }
    }
    Return $Script:Config.ApiList
}