function Update-Desktop{
    [cmdletbinding()]
    param(
        [Parameter(Mandatory)]
        [Vmware.Hv.DesktopId]$DesktopId,
        [Parameter(Mandatory)]
        [ValidateScript({$_[0] -is [Vmware.Hv.MapEntry]})]
        $Updates,
        [Parameter(Mandatory)]
        [Vmware.Hv.Services]$hvApi
    )
    Return $hvApi.Desktop.Desktop_Update($DesktopId,$Updates)
}