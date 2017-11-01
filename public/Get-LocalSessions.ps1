function Get-LocalSessions {
    [cmdletbinding()]
    param(
        [Parameter(ParameterSetName="Server")]
        [ValidateScript({$_ -in $Script:ApiList.Keys})]
            [String]$Server = $Script:Config.CurrentServer
    )
    $Select = @(
        @{N='ComputerName';E={$_.NamesData.MachineOrRDSServerName}},
        @{N='DesktopPool';E={$_.NamesData.DesktopName}},
        @{N='DNS';E={$_.NamesData.MachineOrRDSServerDNS}},
        @{N='User';E={$_.NamesData.UserName}},
        @{N='StartTime';E={$_.SessionData.StartTime}},
        @{N='SessionProtocol';E={$_.SessionData.SessionProtocol}},
        '*'
    )
    $Sessions = Search-HV -QueryType SessionLocalSummaryView -Server $Server | Select $Select
    Return $Sessions
}
