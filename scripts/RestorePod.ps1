[cmdletbinding(SupportsShouldProcess)]
param(
    [Parameter(Mandatory)]
    [ValidateSet('A','B')]
    $Pod
)


$DesktopMapFile = "$env:USERPROFILE\DesktopMap.xml"
$DesktopMap = Import-Clixml -Path $DesktopMapFile
$ApplicationMapFile = "$env:USERPROFILE\ApplicationMap.xml"
$ApplicationMap = Import-Clixml -Path $ApplicationMapFile

$DesktopMap.GetEnumerator() | ForEach-Object{
    $Name = $_.Key
    $GeId = $_.Value
    if ($GeId -ne $null){
        Set-DesktopEntitlement -Desktop $Name -Server $Pod -GeId $GeId
    }
}
$ApplicationMap.GetEnumerator() | ForEach-Object{
    $Name = $_.Key
    $GeID = $_.Value
    If ($GeID -ne $null){
        Set-ApplicationEntitlement -Application $Name -Server $Pod -GeId $GeId
    }
}