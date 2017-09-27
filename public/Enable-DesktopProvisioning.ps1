function Enable-DesktopProvisioning{
    [cmdletbinding(SupportsShouldProcess,DefaultParameterSetName="Desktop")]
    param(
        [Parameter(Mandatory,ParameterSetName="Desktop")]
        [String]$Desktop,
        [Parameter(Mandatory,dontshow,ParameterSetName="DesktopId")]
        [VMware.Hv.DesktopId]$DesktopId,
        [Parameter()]
        [ValidateScript({$_ -in $Script:Config.ApiList.Keys})]
        [String]$Server = $Script:Config.CurrentServer
    )
    if ($PSCmdlet.ParameterSetName -eq "Desktop"){
        $DesktopObject = Get-DesktopPool -Name $Desktop
        $DesktopId = $DesktopObject.Id
    }
    $Update = New-MapEntry @{'automatedDesktopData.virtualCenterProvisioningSettings.enableProvisioning' = $True}
    Return Invoke-ViewApi -ApiPath "Desktop.Desktop_Update" -ArgumentList $DesktopId,$Update -Server $Server
}