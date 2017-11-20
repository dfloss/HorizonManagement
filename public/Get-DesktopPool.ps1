function Get-DesktopPool{
    [OutputType([Vmware.Hv.DesktopInfo])]
    [cmdletbinding(DefaultParameterSetName='Server')]
    param(
        [Parameter(Mandatory=$false)]
        [String]$Name,
        [Parameter(ParameterSetName="Api",Mandatory)]
        [VMware.Hv.Services]$HvApi,
        [Parameter(ParameterSetName="Server")]
        [ValidateScript({$_ -in $Script:ApiList.Keys})]
        [String]$Server = $Script:Config.CurrentServer
    )
    if ($PSCmdlet.ParameterSetName -eq 'Server'){
        $HvApi = Get-HvApi -Server $Server
    }
    #Select Block for DesktopPools, this puts some important information at the top level
    #Select array is assembled with * to keep the other objects intact for backwards compatibility.
    $Select = @('*')
    #Setup as Key = Name and Value = Expression for more compact notation
    $SelectHash = @{
        'Name' = {$_.Base.Name}
        'DisplayName' = {$_.Base.DisplayName}
        'Enabled' = {$_.DesktopSettings.Enabled}
        'Provisioning' = {$_.AutomatedDesktopData.VirtualCenterProvisioningSettings.EnableProvisioning}
        'ParentVmPath' = {$_.AutomatedDesktopData.VirtualCenterNamesData.ParentVmPath}
    }
    $SelectHash.GetEnumerator() | ForEach-Object{
        $Statement = @{N=$_.Key;E=$_.Value}
        $Select+=$Statement
    }
    $DesktopSummary = Search-HV -HvApi $hvApi -QueryType DesktopSummaryView
    if ($Name){
        $Desktop = $DesktopSummary | Where {$_.DesktopSummaryData.Name -like $Name} | Select $Select
        if ($Desktop -eq $Null){
            Write-Warning "No Desktop Pool name $Name was Found"
            Return $null
        }
        else{
            $Desktop = $hvApi.Desktop.Desktop_Get($Desktop.Id)
            Return $Desktop
        }
    }
    else{
        $ReturnObject = [System.Collections.Arraylist]::new()
        foreach($DesktopId in $DesktopSummary.id){
            $Desktop = $hvApi.Desktop.Desktop_Get($DesktopId) | Select $Select
            $ReturnObject.add($Desktop) | Out-Null
        }
        Return $ReturnObject
    }
}