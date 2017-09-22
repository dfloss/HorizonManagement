function Set-DesktopEntitlement{
    [cmdletbinding(SupportsShouldProcess,DefaultParameterSetName = "GlobalEntitlement")]
    param(
        [Parameter(Mandatory)]
        [String]$Desktop,
        [Parameter(Mandatory,ParameterSetName="GlobalEntitlement")]
        [String]$GlobalEntitlement,
        [Parameter(Mandatory,ParameterSetName="GeId")]
        [VMware.Hv.GlobalEntitlementId]$GeId,
        [Parameter()]
        [ValidateScript({$_ -in $Script:Config.ApiList.Keys})]
        [String]$Server = $Script:Config.CurrentServer,
        [Parameter(dontshow)]
        [VMware.Hv.Services]$HvApi
    )
    if (-not $HvApi){
        $HvApi = Get-HvApi -Server $Server
    }

    $PoolID = (Get-DesktopPool -Name $Desktop -HvApi $HvApi).Id
    if ($PoolID -like $Null){
        throw "Unable to find desktop pool called: $Desktop"
    }

    Switch ($PSCmdlet.ParameterSetName){
        "GlobalEntitlement"{
            $GeId = (Get-GlobalEntitlement -Name $GlobalEntitlement).Id
            If ($GeId -like $Null){
                throw "Unable to find Global Entitlement called: $GlobalEntitlement"
            }
        }
    }

    $Update = [VMware.Hv.MapEntry]::new()
    $Update.Value = $GeId
    $Update.Key = 'globalEntitlementData.globalEntitlement'
    If ($PSCmdlet.ShouldProcess($Desktop,"Adding Global Entitlement: $GlobalEntitlement")){
        Invoke-ViewApi -ApiPath "Desktop.Desktop_Update" -ArgumentList $PoolID,$Update -Server $Server
        #Return $HvApi.Desktop.Desktop_Update($PoolID,$Update)
    }
}