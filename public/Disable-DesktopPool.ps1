function Disable-DesktopPool{
    [cmdletbinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory,ParameterSetName="Desktop")]
        [String]$Desktop,
        [Parameter()]
        [ValidateScript({$_ -in $Script:Config.ApiList.Keys})]
        [String]$Server = $Script:Config.CurrentServer
    )
    $Params = @{
        Desktop = $Desktop
        Key = 'desktopSettings.enabled'
        Value = $false
        Server = $Server
    }
    Set-DesktopPool @Params
}