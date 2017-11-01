function Register-CompleterList{
    param(
        [HashTable]$Commands,
        [ScriptBlock]$Completer
    )
    $Commands.GetEnumerator() | Foreach {
        Register-ArgumentCompleter -CommandName $_.Key -ParameterName $_.Value -ScriptBlock $Completer
    }
}

$ServerSelectionCompleter = {
    $Script:Config.ApiList.GetEnumerator() | Foreach-Object {
        $Name = $_.Key
        $Server = $_.Value.ConnectionServer.Client.ServiceUri.Host
        [System.Management.Automation.CompletionResult]::new("'$Name'","$Name",'ParameterValue',"$Name $Server")
    }
}
$Commands = @{
    'Connect-HVServerList' = 'Server'
    'Connect-HVServerList.Tests' = 'Server'
    'Disable-DesktopPool' = 'Server'
    'Disable-DesktopProvisioning' = 'Server'
    'Disable-Pod' = 'Server'
    'Enable-DesktopPool' = 'Server'
    'Enable-DesktopProvisioning' = 'Server'
    'Enable-Pod' = 'Server'
    'Get-ApplicationPool' = 'Server'
    'Get-DesktopPool' = 'Server'
    'Get-GlobalApplicationEntitlement' = 'Server'
    'Get-GlobalEntitlement' = 'Server'
    'Get-LocalSessions' = 'Server'
    'Remove-ApplicationEntitlement' = 'Server'
    'Remove-DesktopEntitlement' = 'Server'
    'Search-HV' = 'Server'
    'Set-ApplicationEntitlement' = 'Server'
    'Set-CurrentHVServer' = 'Server'
    'Set-DesktopEntitlement' = 'Server'
    'Set-DesktopPool' = 'Server'
    'Set-DesktopPool.Tests' = 'Server'
    'Set-PoolGlobalEntitlement' = 'Server'
}
Register-CompleterList -Commands $Commands -Completer $ServerSelectionCompleter


$ApplicationPoolCompleter = {
    (Search-HV -QueryType ApplicationInfo).Data.Name | Sort | ForEach-Object{
        New-Object -TypeName 'System.Management.Automation.CompletionResult' "'$_'","$_",'ParameterValue',"$_"
    }
}
$Commands = @{
    "Get-ApplicationPool" = "Name"
    "Set-ApplicationEntitlement" = "Application"
    'Remove-ApplicationEntitlement' = 'Application'
}
Register-CompleterList -Commands $Commands -Completer $ApplicationPoolCompleter

$DesktopPoolCompleter = {
    (Search-HV -QueryType DesktopSummaryView).DesktopSummaryData.Name | Sort | ForEach-Object{
        New-Object -TypeName 'System.Management.Automation.CompletionResult' "'$_'","$_",'ParameterValue',"$_"
    }
}
$Commands = @{
    'Disable-DesktopPool' = 'Desktop'
    'Disable-DesktopProvisioning' = 'Desktop'
    'Enable-DesktopPool' = 'Desktop'
    'Enable-DesktopProvisioning' = 'Desktop'
    'Get-DesktopPool' = 'Name'
    'Remove-DesktopEntitlement' = 'Desktop'
    'Set-DesktopEntitlement' = 'Desktop'
    'Set-DesktopPool' = 'Desktop'
}
Register-CompleterList -Commands $commands -Completer $DesktopPoolCompleter

$GlobalEntitlementCompleter = {
    (Search-HV -QueryType GlobalEntitlementSummaryView).Base.DisplayName | Sort | ForEach-Object{
        New-Object -TypeName 'System.Management.Automation.CompletionResult' "'$_'","$_",'ParameterValue',"$_"
    }
}
Register-ArgumentCompleter -CommandName 'Get-GlobalEntitlement' -ParameterName 'Name' -ScriptBlock $GlobalEntitlementCompleter
Register-ArgumentCompleter -CommandName 'Set-DesktopEntitlement' -ParameterName 'GlobalEntitlement' -ScriptBlock $GlobalEntitlementCompleter

$GlobalApplicationEntitlementCompleter = {
    (Search-HV -QueryType GlobalApplicationEntitlementInfo).Base.DisplayName | Sort | ForEach-Object{
        New-Object -TypeName 'System.Management.Automation.CompletionResult' "'$_'","$_",'ParameterValue',"$_"
    }
}
Register-ArgumentCompleter -CommandName 'Get-GlobalApplicationEntitlement' -ParameterName 'Name' -ScriptBlock $GlobalApplicationEntitlementCompleter
Register-ArgumentCompleter -CommandName 'Set-ApplicationEntitlement' -ParameterName 'GlobalEntitlement' -ScriptBlock $GlobalApplicationEntitlementCompleter

$DesktopPropertiesCompleter = {
    $Script:Config.DesktopProperties | foreach {
        $Preview = $_ -replace "^[a-zA-Z]+\.",""
        New-Object -TypeName 'System.Management.Automation.CompletionResult' "'$_'","$Preview",'ParameterValue',"$_"
    }
}
Register-ArgumentCompleter -CommandName 'Set-DesktopPool' -ParameterName "Key" -ScriptBlock $DesktopPropertiesCompleter