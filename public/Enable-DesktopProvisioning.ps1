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
    $Params = @{
        Desktop = $Desktop
        Key = 'automatedDesktopData.virtualCenterProvisioningSettings.enableProvisioning'
        Value = $true
        Server = $Server
    }
    Set-DesktopPool @Params

}