$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

Describe "Connect-HVServerList" -Tag "Unit"{
    BeforeEach{
        #Mock the ApiList internal script
        $Script:Config = [PSCustomObject]@{
            ApiList = @{}
        }
    }
    #Mock credential imports with a valid credential
    $MockPass = "Test" | ConvertTo-SecureString -AsPlainText -Force
    $MockCredential = New-Object System.Management.Automation.PSCredential -argumentlist "Test",$MockPass
    Mock -CommandName "Import-CliXml" -MockWith {$MockPass = "Test" | ConvertTo-SecureString -AsPlainText -Force
        Return New-Object System.Management.Automation.PSCredential -argumentlist "Test",$MockPass
    } -Verifiable
    Mock -CommandName "Get-Credential" -MockWith {$MockPass = "Test" | ConvertTo-SecureString -AsPlainText -Force
        Return New-Object System.Management.Automation.PSCredential -argumentlist "Test",$MockPass
    } -Verifiable
    Mock -CommandName "Set-CurrentHVServer"
    #Mock Connect-HvServer to return a dummy test object
    Mock -CommandName "Connect-HVServer" -MockWith {Return [PSCustomObject]@{ExtensionData=@{server=$server;credential=$Credential}}}
    #Mock -CommandName "Connect-HVServer" -MockWith {Return [PSCustomObject]@{ExtensionData="Test"}}
    It "Connects to all Servers passed in a Hashtable and assigns their names to an internal variable"{
        $TestHash = @{
            'Server1' = 'Server1.company.com'
            'Server2' = 'Server2.company.com'
        }
        $ExpectedApiList = @{
            'Server1' = @{server='Server1.company.com';credential=$MockCredential}
            'Server2' = @{server='Server2.company.com';credential=$MockCredential}
        }
        Connect-HvServerList -ServerHash $TestHash  | Out-Null
        #this is ugly but pester leaves me no choice since I can't compare complex objects
        $Script:Config.ApiList.GetEnumerator() | Foreach {
            $Key = $_.Key
            $Value = $_.Value
            {$Key -in $ExpectedApiList.Keys} | Should Be $True
            $Value.Server | Should Be $ExpectedApiList.$Key.Server
            $Value.Credential.userName | Should Be $ExpectedApiList.$Key.Credential.Username
            $value.Credential.GetNetworkCredential().Password | Should Be $ExpectedApiList.$Key.Credential.GetNetworkCredential().Password
        }
        {$Script:Config.ApiList.Values[0] -eq $ExpectedApiList.Values[0]} | Should Be $True
    }
    It "Connects to a single server with the specified url as both the connection and the name"{
        $Server = "server.company.com"
        Connect-HvServerList -Server $Server -Credential $MockCredential
        $Script:Config.ApiList.$Server.Server| Should be $Server
        $Script:Config.ApiList.$Server.Credential.Username| Should be $MockCredential.UserName
        $Script:Config.ApiList.$Server.Credential.GetNetworkCredential().Password| Should be $MockCredential.GetNetworkCredential().Password
    }
}
