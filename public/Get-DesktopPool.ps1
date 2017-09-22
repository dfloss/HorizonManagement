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
    $DesktopSummary = Search-HV -HvApi $hvApi -QueryType DesktopSummaryView
    if ($Name){
        $Desktop = $DesktopSummary | Where {$_.DesktopSummaryData.Name -like $Name}
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
            $Desktop = $hvApi.Desktop.Desktop_Get($DesktopId)
            $ReturnObject.add($Desktop) | Out-Null
        }
        Return $ReturnObject
    }
}