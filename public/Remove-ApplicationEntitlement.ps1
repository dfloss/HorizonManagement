function Remove-ApplicationEntitlement{
    [cmdletbinding(DefaultParameterSetName="Server")]
    param(
        [Parameter()]
        [String]$Application,
        [Parameter(ParameterSetName="Api",Mandatory)]
        [VMware.Hv.Services]$HvApi,
        [Parameter(ParameterSetName="Server")]
        [ValidateScript({$_ -in $Script:ApiList.Keys})]
        [String]$Server = $Script:Config.CurrentServer
    )
    if ($PSCmdlet.ParameterSetName -eq 'Server'){
        Write-Verbose "Assigning HvApi"
        $HvApi = Get-HvApi -Server $Server
    }
    $PoolID = (Get-ApplicationPool -Name $Application -Server $Server).Id
    if ($PoolId -like $Null){
        throw "Unable to find application pool called: $Application"
    }

    $Update = [VMware.Hv.MapEntry]::new()
    $Update.Key = 'data.globalApplicationEntitlement'
    $Update.Value = $null

    If ($PSCmdlet.ShouldProcess($Application,"Removing Global Entitlement")){
        Return $HvApi.Application.Application_Update($PoolID,$Update)
    }
}