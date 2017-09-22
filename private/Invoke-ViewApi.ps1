Function Invoke-ViewApi{
    param(
        [Parameter(Mandatory)]
        $ApiPath,
        [Parameter(ParameterSetName="Argument")]
        $ArgumentList,
        [Parameter(Mandatory)]
        $Server
    )
    $Api = Get-HvApi -Server $Server
    $PathArray = $ApiPath -split "\."
    foreach ($item in $PathArray){
        $Api = $Api.$Item
    }

    if ($PSCmdlet.ParameterSetName -eq "Argument"){
        $Api.Invoke($ArgumentList)
    }
    else{
        $Api.Invoke()
    }
}