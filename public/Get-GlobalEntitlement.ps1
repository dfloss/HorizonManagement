Function Get-GlobalEntitlement{
    [OutputType([VMware.Hv.GlobalEntitlementInfo])]
    [cmdletbinding(DefaultParameterSetName='Server',SupportsShouldProcess)]
    param(
        [Parameter(Mandatory=$false)]
        [String]$Name,
        [Parameter(Mandatory=$false,dontshow)]
        $GeId,
        [Parameter(ParameterSetName="Api",Mandatory)]
        [VMware.Hv.Services]$HvApi,
        [Parameter(ParameterSetName="Server")]
        [ValidateScript({$_ -in $Script:ApiList.Keys})]
        [String]$Server = $Script:Config.CurrentServer
    )
    if ($PSCmdlet.ParameterSetName -eq 'Server'){
        $HvApi = Get-HvApi -Server $Server
    }
    $GeSummary = Search-HV -HvApi $hvApi -QueryType GlobalEntitlementSummaryView
    if ($Name -or $GeId){
        If ($Name){
            $GE = $GeSummary | Where {$_.Base.DisplayName -like $Name}
            if ($GE -eq $Null){
                Write-Warning "No Global Entitlement named $Name was found"
                Return $null
            }
            else{
                $GE = $hvApi.GlobalEntitlement.GlobalEntitlement_Get($GE.Id)
            }
        }
        ElseIf ($GeID){
            $GE = $HvApi.GlobalEntitlement.GlobalEntitlement_Get($GeId)
        }
        Return $GE
    }
    else{
        $ReturnObject = [System.Collections.Arraylist]::new()
        foreach($GEId in $GeSummary.id){
            $GE = $hvApi.GlobalEntitlement.GlobalEntitlement_Get($GEId)
            $ReturnObject.add($GE) | Out-Null
        }
        Return $ReturnObject
    }
}