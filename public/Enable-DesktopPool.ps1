function Enable-DesktopPool{
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
    $Params = @{
        Desktop = $Desktop
        Key = 'desktopSettings.enabled'
        Value = $true
        Server = $Server
    }
    Set-DesktopPool @Params
}