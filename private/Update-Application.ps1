function Update-Application{
    [cmdletbinding()]
    param(
        [Parameter(Mandatory)]
        [VMware.Hv.ApplicationId]$ApplicationId,
        [Parameter(Mandatory)]
        [ValidateScript({$_[0] -is [Vmware.Hv.MapEntry]})]
        $Updates,
        [Parameter(Mandatory)]
        [Vmware.Hv.Services]$hvApi
    )
    Return $hvApi.Application.Application_Update($ApplicationId,$Updates)
}