function Set-CurrentHvServer{
    [cmdletbinding()]
    param(
        [Parameter()]
        [ValidateScript({$_ -in $Script:Config.ApiList.Keys})]
        [String]$Server
    )
    $Script:Config.CurrentServer = $Server
}
