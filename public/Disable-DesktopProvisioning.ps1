function Disable-DesktopProvisioning{
    [cmdletbinding(SupportsShouldProcess,DefaultParameterSetName="Desktop")]
    param(
        [Parameter(Mandatory,ParameterSetName="Desktop")]
        [String]$Desktop,
        [Parameter(Mandatory,dontshow,ParameterSetName="DesktopId")]
        [VMware.Hv.DesktopId]$DesktopId,
        [Parameter()]
        [ValidateScript({$_ -in $Script:Config.ApiList.Keys})]
        [String]$Server = $Script:Config.CurrentServer,
        [Parameter(dontshow)]
        [VMware.Hv.Services]$HvApi
    )
    if (-not $HvApi){
        $HvApi = Get-HvApi -Server $Server
    }
    if ($PSCmdlet.ParameterSetName -eq "Desktop"){
        $DesktopObject = Get-DesktopPool -Name $Desktop
        $DesktopId = $DesktopObject.Id
    }
    $Update = [VMware.Hv.MapEntry]::new
    $Update.Key = 'automatedDesktopData.virtualCenterProvisioningSettings.enableProvisioning'
    $Update.Value = $false
    #Return $HvApi.Desktop.Desktop_Update($DesktopId,$Update)
    Return Invoke-ViewApi -ApiPath "Desktop.Desktop_Update" -ArgumentList $DesktopId,$Update
}