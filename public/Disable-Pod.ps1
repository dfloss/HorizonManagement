function Disable-Pod{
    [cmdletbinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory)]
        $Server,
        [ParameteR(Mandatory)]
        $EntitlementBackupFile,
        [Parameter()]
        [Switch]$BackupOnly
    )
    $HvApi = Get-HvApi -Server $Server

    $DesktopSelect = @(
        @{N='Name';E={$_.Base.Name}},
        @{N='GeId'; E={$_.GlobalEntitlementData.GlobalEntitlement}},
        @{N='PoolType';E={'Desktop'}}
    )
    $DesktopPools = Get-DesktopPool -Server $Server | Select $DesktopSelect

    $ApplicationSelect = @(
        @{N='Name';E={$_.Data.Name}},
        @{N='GeId'; E={$_.Data.GlobalApplicationEntitlement}},
        @{N='PoolType';E={'Application'}}
    )
    $ApplicationPools = get-ApplicationPool -Server $Server | Select $ApplicationSelect
    $Pools = @($DesktopPools + $ApplicationPools)

    $Pools | Export-Clixml -Path $EntitlementBackupFile 
    
    If (-not $BackupOnly){
        foreach ($Pool in $Pools){
           if ($PSCmdlet.ShouldProcess($Pool.Name,"Removing GlobalEntitlement")){ 
                Switch($Pool.PoolType){
                    "Desktop"{
                        Remove-DesktopEntitlement -Desktop $Pool.Name
                    }
                    "Application"{
                        Remove-ApplicationEntitlement -Application $Pool.Name
                    }
                }
            }
        }
    }
}