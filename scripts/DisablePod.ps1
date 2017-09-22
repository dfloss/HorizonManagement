[cmdletbinding(SupportsShouldProcess)]
param(
    [Parameter(Mandatory)]
    [ValidateSet('A','B')]
    $Pod,
    [switch]$BackupOnly
)

$DesktopMap = @{}
$DesktopMapFile = "$env:USERPROFILE\DesktopMap.xml"
$ApplicationMap = @{}
$ApplicationMapFile = "$env:USERPROFILE\ApplicationMap.xml"


$Desktops = Get-DesktopPool -Server $Pod -ErrorAction Stop
foreach ($Desktop in $Desktops){
    $Name = $Desktop.Base.Name
    $GeId = $Desktop.GlobalEntitlementData.GlobalEntitlement
    $DesktopMap.add($Name,$GeId)
    if ($BackupOnly){
        $GeName = (Get-GlobalEntitlement -GeId $GeId).Base.DisplayName
        Write-Output "Backing up Desktop Pool $Name with Global Entitlement $GeName"
    }
}
Export-Clixml -Path $DesktopMapFile -InputObject $DesktopMap -Force -ErrorAction Stop

$Applications = Get-ApplicationPool -Server $Pod -ErrorAction Stop
foreach ($Application in $Applications){
    $Name = $Application.Data.Name
    $GeId = $Application.Data.GlobalApplicationEntitlement
    $ApplicationMap.add($Name,$GeId)
    if ($BackupOnly){
        $GeName = (Get-GlobalApplicationEntitlement -GeId $GeId).Base.DisplayName
        Write-Output "Backing up Application Pool $Name with Global Entitlement $GeName"
    }
}
Export-Clixml -Path $ApplicationMapFile -InputObject $ApplicationMap -Force -ErrorAction Stop
Write-Output $DesktopMap
Write-Output $ApplicationMap

If (-not $BackupOnly){
    $DesktopMap.GetEnumerator() | ForEach-Object{
        $Name = $_.Key
        Remove-DesktopEntitlement -Desktop $Name -Server $Pod
    }
    $ApplicationMap.GetEnumerator() | ForEach-Object{
        $Name = $_.Key
        Remove-ApplicationEntitlement -Application $Name -Server $Pod
    }
}