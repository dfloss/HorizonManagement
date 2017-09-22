function Enable-Pod{
    [cmdletbinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory)]
        $Server,
        [Parameter(Mandatory)]
        $EntitlementBackupFile
    )
    $hvApi = Get-HvApi -Server $Server
    $Entries = Import-Clixml $EntitlementBackupFile

    foreach ($Entry in $Entries){
        If ($PSCmdlet.ShouldProcess($Entry.Name, "Restoring GlobalEntitlement")){
            switch ($Entry.PoolType){
                "Desktop"{
                    Set-DesktopEntitlement -Desktop $Entry.Name -GeId $Entry.GeId -Server $Server
                }
                "Application"{
                    Set-ApplicationEntitlement -Application $Entry.Name -GeId $Entry.GeId -Server $Server
                }
            }
        }
    }
}