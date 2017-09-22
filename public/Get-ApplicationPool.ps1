function get-ApplicationPool{
    [OutputType([Vmware.Hv.ApplicationInfo])]
    [cmdletbinding(DefaultParameterSetName="Server")]
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

    $ApplicationInfo = Search-HV -QueryType ApplicationInfo -HvApi $HvApi
    if ($Name){
        $Application = $ApplicationInfo | Where {$_.Data.Name -like $Name}
        if ($Application -eq $Null){
            Write-Warning "No Desktop Pool name $Name was Found"
            Return $null
        }
        else{
            $Application = $hvApi.Application.Application_Get($Application.Id)
            Return $Application
        }
    }
    else{
        $ReturnObject = [System.Collections.Arraylist]::new()
        foreach($ApplicationId in $ApplicationInfo.id){
            $Application = $hvApi.Application.Application_Get($ApplicationId)
            $ReturnObject.add($Application) | Out-Null
        }
        Return $ReturnObject
    }
}