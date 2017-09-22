function Remove-DesktopEntitlement{
    [cmdletbinding(DefaultParameterSetName="Server",SupportsShouldProcess)]
    param(
        [Parameter()]
        [String]$Desktop,
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
    $PoolID = (Get-DesktopPool -Name $Desktop -Server $Server).Id
    if ($PoolId -like $Null){
        throw "Unable to find Desktop pool called: $Desktop"
    }

    $Update = [VMware.Hv.MapEntry]::new()
    $Update.Key = 'globalEntitlementData.globalEntitlement'
    $Update.Value = $null

    If ($PSCmdlet.ShouldProcess($Desktop,"Removing Global Entitlement")){
        Return $HvApi.Desktop.Desktop_Update($PoolID,$Update)
    }
}