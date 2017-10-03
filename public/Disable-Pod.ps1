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
    $ApplicationSelect = @(
        @{N='Name';E={$_.Data.Name}},
        @{N='GeId'; E={$_.Data.GlobalApplicationEntitlement}},
        @{N='PoolType';E={'Application'}}
    )

    Try {
        $DesktopPools = Get-DesktopPool -Server $Server -ErrorAction Stop | Select $DesktopSelect -ErrorAction Stop
        $ApplicationPools = get-ApplicationPool -Server $Server -ErrorAction Stop | Select $ApplicationSelect -ErrorAction Stop
        $Pools = @($DesktopPools + $ApplicationPools)
        $Pools | Export-Clixml -Path $EntitlementBackupFile -ErrorAction Stop
    }
    Catch{
        Write-Error "Unable to Create Backup, aborting Pod Disable"
        Throw $_
    }
    
    If (-not $BackupOnly){
        foreach ($Pool in $Pools){
           if ($PSCmdlet.ShouldProcess($Pool.Name,"Removing GlobalEntitlement")){ 
                Switch($Pool.PoolType){
                    "Desktop"{
                        Remove-DesktopEntitlement -Desktop $Pool.Name -Server $Server
                    }
                    "Application"{
                        Remove-ApplicationEntitlement -Application $Pool.Name -Server $Server
                    }
                }
            }
        }
    }
}