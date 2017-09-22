[cmdletbinding()]
    Param(
        [Switch]$Force
    )
    $Params = @{
        Path = "$PSScriptRoot\config.default.ps1"
        Destination = "$PSScriptRoot\config.ps1"
        Force = $Force
    }
    Copy-Item @Params
    Write-Information -MessageData "Please Review the file at`
      $($Params.Destination) to fully configure this module"
}