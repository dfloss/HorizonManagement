$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

Describe "Connect-HVServerList" -Tag "Unit"{
    #Mock the ApiList internal script
    $Script:Config = [PSCustomObject]@{
        ApiList = @{}
    }
    #Mock credential import with a valid credential
    $MockCredential = New-Object System.Management.Automation.PSCredential("Test","Test")
    Mock -CommandName "Import-CliXml" -MockWith {Return (New-Object System.Management.Automation.PSCredential("Test","Test"))}
    Mock -CommandName ""

}
