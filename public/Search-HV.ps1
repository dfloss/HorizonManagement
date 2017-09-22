function Search-HV{
    [cmdletbinding(DefaultParameterSetName='Server')]
    param(
        [Parameter()]
        [ValidateSet(
            'ADUserOrGroupSummaryView',
            'ApplicationIconInfo',
            'ApplicationInfo',
            'DesktopSummaryView',
            'EntitledUserOrGroupGlobalSummaryView',
            'EntitledUserOrGroupLocalSummaryView',
            'FarmHealthInfo',
            'FarmSummaryView',
            'GlobalApplicationEntitlementInfo',
            'GlobalEntitlementSummaryView',
            'MachineNamesView',
            'MachineSummaryView',
            'PersistentDiskInfo',
            'PodAssignmentInfo',
            'RDSServerInfo',
            'RDSServerSummaryView',
            'RegisteredPhysicalMachineInfo',
            'SessionGlobalSummaryView',
            'SessionLocalSummaryView',
            'TaskInfo',
            'UserHomeSiteInfo'
    )]
        $QueryType,
        [Parameter(ParameterSetName="Api",Mandatory)]
        [VMware.Hv.Services]$HvApi,
        [Parameter(ParameterSetNAme="Server")]
        [ValidateScript({$_ -in $Script:Config.ApiList.Keys})]
        [String]$Server = $Script:Config.CurrentServer
    )
    if ($PSCmdlet.ParameterSetName -eq 'Server'){
        $HvApi = Get-HvApi -Server $Server
    }
    $qSvc = $hvApi.QueryService
    $query = [VMware.Hv.QueryDefinition]::new()
    $query.QueryEntityType = $QueryType
    $queryResult = $qSvc.QueryService_Query($query)
    $results = $queryResult.Results
    $Results
#$Ids = $results | select @{N='Id';E={$_.id}},@{N='Name';E={$_.Base.DisplayName}}
}