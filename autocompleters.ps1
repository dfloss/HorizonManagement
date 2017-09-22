$ServerSelectionCompleter = {
    $Script:Config.ApiList.GetEnumerator() | Foreach-Object {
        $Name = $_.Key
        $Server = $_.Value.ConnectionServer.Client.ServiceUri.Host
        [System.Management.Automation.CompletionResult]::new("'$Name'","$Name",'ParameterValue',"$Name $Server")
    }
}
Register-ArgumentCompleter -CommandName "Search-HV" -ParameterName 'Server' -ScriptBlock $ServerSelectionCompleter
Register-ArgumentCompleter -CommandName "Get-DesktopPool" -ParameterName 'Server' -ScriptBlock $ServerSelectionCompleter
Register-ArgumentCompleter -CommandName "Set-CurrentHvServer" -ParameterName 'Server' -ScriptBlock $ServerSelectionCompleter
Register-ArgumentCompleter -CommandName "Set-DesktopEntitlement" -ParameterName 'Server' -ScriptBlock $ServerSelectionCompleter
Register-ArgumentCompleter -CommandName "Remove-DesktopEntitlement" -ParameterName 'Server' -ScriptBlock $ServerSelectionCompleter

$ApplicationPoolCompleter = {
    (Search-HV -QueryType ApplicationInfo).Data.Name | Sort | ForEach-Object{
        New-Object -TypeName 'System.Management.Automation.CompletionResult' "'$_'","$_",'ParameterValue',"$_"
    }
}
Register-ArgumentCompleter -CommandName 'Get-ApplicationPool' -ParameterName 'Name' -ScriptBlock $ApplicationPoolCompleter
Register-ArgumentCompleter -CommandName 'Set-ApplicationEntitlement' -ParameterName 'Application' -ScriptBlock $ApplicationPoolCompleter
Register-ArgumentCompleter -CommandName 'Remove-ApplicationEntitlement' -ParameterName 'Application' -ScriptBlock $ApplicationPoolCompleter

$DesktopPoolCompleter = {
    (Search-HV -QueryType DesktopSummaryView).DesktopSummaryData.Name | Sort | ForEach-Object{
        New-Object -TypeName 'System.Management.Automation.CompletionResult' "'$_'","$_",'ParameterValue',"$_"
    }
}
Register-ArgumentCompleter -CommandName 'Get-DesktopPool' -ParameterName 'Name' -ScriptBlock $DesktopPoolCompleter
Register-ArgumentCompleter -CommandName 'Set-DesktopEntitlement' -ParameterName 'Desktop' -ScriptBlock $DesktopPoolCompleter
Register-ArgumentCompleter -CommandName 'Remove-DesktopEntitlement' -ParameterName 'Desktop' -ScriptBlock $DesktopPoolCompleter

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