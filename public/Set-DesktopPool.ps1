function Set-DesktopPool{
    [CmdletBinding(DefaultParameterSetName="Single",SupportsShouldProcess)]
    param(
        [Parameter(Mandatory)]
        [String]$Desktop,
        [Parameter(Mandatory,ParameterSetName="Single")]
        [ValidateScript({$_ -in $Script:Config.DesktopProperties})]
        [String]$Key,
        [Parameter(Mandatory,ParameterSetName="Single")]
        [String]$Value,
        [Parameter(Mandatory,ParameterSetName="Multi",ValueFromPipeline)]
        [ValidateScript({$_.Keys -in $Script:Config.DesktopProperties})]
        [HashTable]$HashTable,
        [ValidateScript({$_ -in $Script:Config.ApiList.Keys})]
        [String]$Server = $Script:Config.CurrentServer,
        [Parameter(dontshow)]
        [VMware.Hv.Services]$HvApi
    )
    if (-not $HvApi){
        $HvApi = Get-HvApi -Server $Server
    }

    $DesktopID = (Get-DesktopPool -Name $Desktop -HvApi $HvApi).Id
    if ($DesktopId -like $Null){
        throw "Unable to find desktop pool called: $Desktop"
    }

    Switch ($PSCmdlet.ParameterSetName){
        "Single"{
            $HashTable = @{}
            $HashTable.Add($Key,$Value)
        }
    }
    $Updates = New-MapEntry -HashTable $HashTable
    
    if ($PSCmdlet.ShouldProcess($Desktop, "Applying Settings: `n $HashTable `n")){
        $HvApi.Desktop.Desktop_Update($DesktopId,$Updates)
    }
}