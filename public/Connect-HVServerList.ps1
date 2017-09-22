function Connect-HvServerList{
    [cmdletbinding(DefaultParameterSetName="ServerHash")]
    param(
        [Parameter(ParameterSetName="ServerHash")]
        $ServerHash = $Script:Config.Servers,
        [Parameter(ParameterSetName="Server")]
        [string]$Server,
        [Parameter(ParameterSetName="UseExisting")]
        [Switch]$UseExisting
    )
    if ($PSCmdlet.ParameterSetName -eq "ServerHash" -and $ServerHash -eq $null){
        $PSCmdlet.ParameterSetName = "ExistingConnections"
    }

    If ($Script:Config.CredentialFile -ne $null){
        $Credential = Import-Clixml -Path $Script:Config.CredentialFile -ErrorAction Stop
    }
    Else {
        $Credential = Get-Credential -Message "Please enter your credentials to connect to your Horizon Servers"
    }

    Switch($PSCmdlet.ParameterSetName){
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
            $Connection = Connect-HVServer -Server $Server
            $Script:Config.ApiList.Add($Server,$Connection)
            Set-CurrentHvServer -Server $Server
        }
        "UseExisting"{
            Foreach ($ServerEntry in $global:DefaultHVServers){
                $Connection = $ServerEntry
                $SCript:Config.ApiList.Add($ServerEntry.Name,$Connection.ExtensionData)
            }
            Set-CurrentHvServer -Server $global:DefaultHvServers[0].Name
        }
    }
}