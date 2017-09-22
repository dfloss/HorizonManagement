function Get-HvApi{
    [cmdletbinding()]
    param(
        [Parameter(Mandatory)]
        [ValidateScript({$_ -in $Script:ApiList.Keys})]
        [String]$Server
    )
        $HvApi = $Script:ApiList[$Server]
        If ($HvApi -eq $null){
            Throw "Unable to Retrieve the Horizon API, make sure you're connected to server $Server"
        }
        else{
            Return $Script:ApiList[$Server]
        }
}