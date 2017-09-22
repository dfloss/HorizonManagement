function Set-PoolGlobalEntitlement{
    [cmdletbinding()]
    param(
        [Parameter(Mandatory,ParameterSetName="Desktop")]
        [String]$Desktop,
        [Parameter(Mandatory,ParameterSetName="Application")]
        [String]$Application,
        [Parameter(Mandatory)]
        [String]$GlobalEntitlement,
        [Parameter(ParameterSetNAme="Server")]
        [ValidateScript({$_ -in $Script:Config.ApiList.Keys})]
        [String]$Server = $Script:Config.CurrentServer
    )
    if ($PSCmdlet.ParameterSetName -eq 'Server'){
        $HvApi = Get-HvApi -Server $Server
    }

    $GE = (Get-GlobalEntitlement -Name $GlobalEntitlement).Id
    If ($GE -like $Null){
        throw "Unable to find Global Entitlement called: $GlobalEntitlement"
    }

    $Update = [VMware.Hv.MapEntry]::new()
    $UPdate.Value = $GE

    switch ($PSCmdlet.ParameterSetName){
        "Desktop"{
            $PoolID = (Get-DesktopPool -Name $Desktop -HvApi $HvApi).Id
            if ($PoolID -like $Null){
                throw "Unable to find desktop pool called: $Desktop"
            }

            $Update.Key = 'globalEntitlementData.globalEntitlement'
        }
        "Application"{
            $PoolID = (Get-ApplicationPool -Name $Application -HvApi $HvApi).Id
            if ($PoolId -like $Null){
                throw "Unable to find application pool called: $Application"
            }

            $Update.Key = 'data.globalApplicationEntitlement'
        }
    }

    Return $HvApi.Application.Application_Update($PoolID,$Update)
    
}