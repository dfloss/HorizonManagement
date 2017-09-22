Function Get-GlobalApplicationEntitlement{
    [OutputType([VMware.Hv.GlobalApplicationEntitlementInfo])]
    [cmdletbinding(DefaultParameterSetName='Server')]
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
    $GeSummary = Search-HV -HvApi $hvApi -QueryType GlobalApplicationEntitlementInfo
    if ($Name -or $GeID){
        if ($Name){
            $GE = $GeSummary | Where {$_.Base.DisplayName -like $Name}
            if ($GE -eq $Null){
                Write-Warning "No Global Entitlement named $Name was found"
                Return $null
            }
            else{
                $GE = $hvApi.GlobalApplicationEntitlement.GlobalApplicationEntitlement_Get($GE.Id)
            }
        }
        elseif ($GeID){
            $GE = $HvApi.GlobalApplicationEntitlement.GlobalApplicationEntitlement_Get($GeId)
        }
        Return $GE
    }
    else{
        $ReturnObject = [System.Collections.Arraylist]::new()
        foreach($GEId in $GeSummary.id){
            $GE = $hvApi.GlobalApplicationEntitlement.GlobalApplicationEntitlement_Get($GEId)
            $ReturnObject.add($GE) | Out-Null
        }
        Return $ReturnObject
    }
}
