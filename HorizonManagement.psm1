param(
    [Parameter(Position=0)]
    [ValidateSet("Dev","Production")]
    $Mode = "Production",
    [Parameter(Position=1)]
    [bool]$Connect = $True
)
#Get public and private function definition files while excluding tests
    $Public  = @( Get-ChildItem -Path $PSScriptRoot\Public\*.ps1 -ErrorAction SilentlyContinue | Where Name -NotMatch "\.Tests\.ps1$")
    $Private = @( Get-ChildItem -Path $PSScriptRoot\Private\*.ps1 -ErrorAction SilentlyContinue | Where Name -NotMatch "\.Tests\.ps1$")

#Dot source the files
    Foreach($import in @($Public + $Private))
    {
        Try
        {
            . $import.fullname
        }
        Catch
        {
            Write-Error -Message "Failed to import function $($import.fullname): $_"
        }
    }

#Module Variables
$Script:ModuleHome = $PSScriptRoot
$Script:Config = . "$PSScriptRoot\config.ps1"

#Load AutoCompleters
. "$PsScriptRoot\AutoCompleters.ps1"

if ($mode -match "Dev"){
    Export-ModuleMember -Function (@($Public + $Private)).Basename
}
else {
    #Export all public modules
    Export-ModuleMember -Function $Public.Basename
}
