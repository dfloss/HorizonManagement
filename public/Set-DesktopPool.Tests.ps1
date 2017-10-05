$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

Describe "Set-DesktopPool"{
    Context "Happy Path"{
        Mock -CommandName "Get-DesktopPool" -MockWith {Return "DesktopPool"}
    }
}