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
    "Search-HV" = 'Server'
    "Get-DesktopPool" = 'Server'
    'Set-CurrentHVServer' = 'Server'
    'Set-DesktopEntitlement' = 'Server'
    'Remove-DesktopEntitlement' = 'Server'
    'Set-DesktopPool' = 'Server'
    'Disable-DesktopProvisioning' = 'Server'
}
Register-CompleterList -Commands $Commands -Completer $ServerSelectionCompleter
<#
Register-ArgumentCompleter -CommandName "Search-HV" -ParameterName 'Server' -ScriptBlock $ServerSelectionCompleter
Register-ArgumentCompleter -CommandName "Get-DesktopPool" -ParameterName 'Server' -ScriptBlock $ServerSelectionCompleter
Register-ArgumentCompleter -CommandName "Set-CurrentHvServer" -ParameterName 'Server' -ScriptBlock $ServerSelectionCompleter
Register-ArgumentCompleter -CommandName "Set-DesktopEntitlement" -ParameterName 'Server' -ScriptBlock $ServerSelectionCompleter
Register-ArgumentCompleter -CommandName "Remove-DesktopEntitlement" -ParameterName 'Server' -ScriptBlock $ServerSelectionCompleter
#>

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
<#
Register-ArgumentCompleter -CommandName 'Get-ApplicationPool' -ParameterName 'Name' -ScriptBlock $ApplicationPoolCompleter
Register-ArgumentCompleter -CommandName 'Set-ApplicationEntitlement' -ParameterName 'Application' -ScriptBlock $ApplicationPoolCompleter
Register-ArgumentCompleter -CommandName 'Remove-ApplicationEntitlement' -ParameterName 'Application' -ScriptBlock $ApplicationPoolCompleter
#>

$DesktopPoolCompleter = {
    (Search-HV -QueryType DesktopSummaryView).DesktopSummaryData.Name | Sort | ForEach-Object{
        New-Object -TypeName 'System.Management.Automation.CompletionResult' "'$_'","$_",'ParameterValue',"$_"
    }
}
$Commands = @{
    'Get-DesktopPool' = 'Name'
    'Set-DesktopEntitlement' = 'Desktop'
    'Remove-DesktopEntitlement' = 'Desktop'
    'Disable-DesktopProvisioning' = 'Desktop'
    'Enable-DesktopProvisioning' = 'Desktop'
    'Set-DesktopPool' = 'Desktop'
}
Register-CompleterList -Commands $commands -Completer $DesktopPoolCompleter

<#
Register-ArgumentCompleter -CommandName 'Get-DesktopPool' -ParameterName 'Name' -ScriptBlock $DesktopPoolCompleter
Register-ArgumentCompleter -CommandName 'Set-DesktopEntitlement' -ParameterName 'Desktop' -ScriptBlock $DesktopPoolCompleter
Register-ArgumentCompleter -CommandName 'Remove-DesktopEntitlement' -ParameterName 'Desktop' -ScriptBlock $DesktopPoolCompleter
#>
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