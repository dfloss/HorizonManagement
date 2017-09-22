function Set-ApplicationEntitlement{
    [cmdletbinding(DefaultParameterSetName = "Server",SupportsShouldProcess)]
    param(
        [Parameter(Mandatory)]
        [String]$Application,
        [Parameter(Mandatory,ParameterSetName="GlobalEntitlement")]
        [String]$GlobalEntitlement,
        [Parameter(Mandatory,ParameterSetName="GeId")]
        [VMware.Hv.GlobalApplicationEntitlementId]$GeId,
        [Parameter()]
        [ValidateScript({$_ -in $Script:Config.ApiList.Keys})]
        [String]$Server = $Script:Config.CurrentServer,
        [Parameter()]
        [VMware.Hv.Services]$HvApi
    )
    if (-not ($HvApi)){
        Write-Verbose "Assigning HvApi"
        $HvApi = Get-HvApi -Server $Server
    }

    $PoolID = (Get-ApplicationPool -Name $Application -Server $Server).Id
    if ($PoolId -like $Null){
        throw "Unable to find application pool called: $Application"
    }

    Switch ($PSCmdlet.ParameterSetName){
        "GlobalEntitlement"{
            $GeId = (Get-GlobalApplicationEntitlement -Name $GlobalEntitlement).Id
            If ($GeId -like $Null){
                throw "Unable to find Global Application Entitlement called: $GlobalEntitlement"
            }
        }
    }

    $Update = [VMware.Hv.MapEntry]::new()
    $Update.Key = 'data.globalApplicationEntitlement'
    $Update.Value = $GeId

    If ($PSCmdlet.ShouldProcess($Application,"Adding Global Entitlement: $GlobalEntitlement")){
        Return $HvApi.Application.Application_Update($PoolID,$Update)
    }
    
}