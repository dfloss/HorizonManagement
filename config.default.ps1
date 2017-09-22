#====== Make changes Here =========#

#CredentialFile
#File where a clixml file containing a valid credential
#Object is stored, create a credential object by using:
  # Get-Credential | Export-CliXml -Path "<path to file>.xml"
#Leave $null to be prompted for credentials when connecting to
#Horizon Servers
  #Ex: $Credentialfile = $Env:UserProfile\username.xml
$CredentialFile = $null

#Servers
#HashTable to auto connecting to servers The Keys (left side)
# are the  names and the values (right side) are the URLs
#Leave Empty to either specifiy servers when using connect-HVserverlist
# or have Connect-HvServerList Use already established connections
<# Example
$Servers = @{
    A = "vcona01.contoso.com"
    B = "vconb01.contoso.com"
}
#>
$Servers = @{}

#DefaultServer
#Name of the DefaultServer, Sets the current server when the module is imported
#the Current Server is used for intellisense and for cmdlets when the server
#parameter is not defined, Leave $null to require setting the default server after importing the module
#Example: $DefaultServer = "A"
$DefaultServer = $null

#====== End User Config ===========#

$ApiList = @{}

#region Property Lists

$DesktopProperties = @(
    "automatedDesktopData.customizationSettings.cloneprepCustomizationSettings.postSynchronizationScriptName",
    "automatedDesktopData.customizationSettings.cloneprepCustomizationSettings.postSynchronizationScriptParameters",
    "automatedDesktopData.customizationSettings.cloneprepCustomizationSettings.powerOffScriptName",
    "automatedDesktopData.customizationSettings.cloneprepCustomizationSettings.powerOffScriptParameters",
    "automatedDesktopData.customizationSettings.customizationType",
    "automatedDesktopData.customizationSettings.domainAdministrator",
    "automatedDesktopData.customizationSettings.noCustomizationSettings",
    "automatedDesktopData.customizationSettings.quickprepCustomizationSettings",
    "automatedDesktopData.customizationSettings.reusePreExistingAccounts",
    "automatedDesktopData.customizationSettings.sysprepCustomizationSettings",
    "automatedDesktopData.provisioningStatusData.instantCloneProvisioningStatusData.instantCloneCurrentImageState",
    "automatedDesktopData.provisioningStatusData.instantCloneProvisioningStatusData.instantClonePendingImageState",
    "automatedDesktopData.provisioningStatusData.instantCloneProvisioningStatusData.operation",
    "automatedDesktopData.provisioningStatusData.instantCloneProvisioningStatusData.pendingImageParentVm",
    "automatedDesktopData.provisioningStatusData.instantCloneProvisioningStatusData.pendingImageParentVmPath",
    "automatedDesktopData.provisioningStatusData.instantCloneProvisioningStatusData.pendingImageSnapshot",
    "automatedDesktopData.provisioningStatusData.instantCloneProvisioningStatusData.pendingImageSnapshotPath",
    "automatedDesktopData.provisioningStatusData.instantCloneProvisioningStatusData.pushImageSettings",
    "automatedDesktopData.provisioningStatusData.lastProvisioningError",
    "automatedDesktopData.provisioningStatusData.lastProvisioningErrorTime",
    "automatedDesktopData.provisioningType",
    "automatedDesktopData.userAssignment.automaticAssignment",
    "automatedDesktopData.userAssignment.userAssignment",
    "automatedDesktopData.virtualCenterManagedCommonSettings.transparentPageSharingScope",
    "automatedDesktopData.virtualCenterNamesData.customizationSpecName",
    "automatedDesktopData.virtualCenterNamesData.datacenterPath",
    "automatedDesktopData.virtualCenterNamesData.datastorePaths",
    "automatedDesktopData.virtualCenterNamesData.hostOrClusterPath",
    "automatedDesktopData.virtualCenterNamesData.networkLabelNames",
    "automatedDesktopData.virtualCenterNamesData.nicNames",
    "automatedDesktopData.virtualCenterNamesData.parentVmPath",
    "automatedDesktopData.virtualCenterNamesData.persistentDiskDatastorePaths",
    "automatedDesktopData.virtualCenterNamesData.replicaDiskDatastorePath",
    "automatedDesktopData.virtualCenterNamesData.resourcePoolPath",
    "automatedDesktopData.virtualCenterNamesData.snapshotPath",
    "automatedDesktopData.virtualCenterNamesData.templatePath",
    "automatedDesktopData.virtualCenterNamesData.vmFolderPath",
    "automatedDesktopData.virtualCenterProvisioningSettings.enableProvisioning",
    "automatedDesktopData.virtualCenterProvisioningSettings.minReadyVMsOnVComposerMaintenance",
    "automatedDesktopData.virtualCenterProvisioningSettings.stopProvisioningOnError",
    "automatedDesktopData.virtualCenterProvisioningSettings.virtualCenterNetworkingSettings.nics",
    "automatedDesktopData.virtualCenterProvisioningSettings.virtualCenterProvisioningData.template",
    "automatedDesktopData.virtualCenterProvisioningSettings.virtualCenterStorageSettings.datastores.storageOvercommit",
    "automatedDesktopData.virtualCenterProvisioningSettings.virtualCenterStorageSettings.useVSan",
    "automatedDesktopData.virtualCenterProvisioningSettings.virtualCenterStorageSettings.viewComposerStorageSettings.nonPersistentDiskSettings.diskDriveLetter",
    "automatedDesktopData.virtualCenterProvisioningSettings.virtualCenterStorageSettings.viewComposerStorageSettings.nonPersistentDiskSettings.diskSizeMB",
    "automatedDesktopData.virtualCenterProvisioningSettings.virtualCenterStorageSettings.viewComposerStorageSettings.nonPersistentDiskSettings.redirectDisposableFiles",
    "automatedDesktopData.virtualCenterProvisioningSettings.virtualCenterStorageSettings.viewComposerStorageSettings.persistentDiskSettings.diskDriveLetter",
    "automatedDesktopData.virtualCenterProvisioningSettings.virtualCenterStorageSettings.viewComposerStorageSettings.persistentDiskSettings.diskSizeMB",
    "automatedDesktopData.virtualCenterProvisioningSettings.virtualCenterStorageSettings.viewComposerStorageSettings.persistentDiskSettings.persistentDiskDatastores",
    "automatedDesktopData.virtualCenterProvisioningSettings.virtualCenterStorageSettings.viewComposerStorageSettings.persistentDiskSettings.redirectWindowsProfile",
    "automatedDesktopData.virtualCenterProvisioningSettings.virtualCenterStorageSettings.viewComposerStorageSettings.persistentDiskSettings.useSeparateDatastoresPersistentAndOSDisks",
    "automatedDesktopData.virtualCenterProvisioningSettings.virtualCenterStorageSettings.viewComposerStorageSettings.replicaDiskDatastore",
    "automatedDesktopData.virtualCenterProvisioningSettings.virtualCenterStorageSettings.viewComposerStorageSettings.spaceReclamationSettings.reclaimVmDiskSpace",
    "automatedDesktopData.virtualCenterProvisioningSettings.virtualCenterStorageSettings.viewComposerStorageSettings.spaceReclamationSettings.reclamationThresholdGB",
    "automatedDesktopData.virtualCenterProvisioningSettings.virtualCenterStorageSettings.viewComposerStorageSettings.useNativeSnapshots",
    "automatedDesktopData.virtualCenterProvisioningSettings.virtualCenterStorageSettings.viewComposerStorageSettings.useSeparateDatastoresReplicaAndOSDisks",
    "automatedDesktopData.virtualCenterProvisioningSettings.virtualCenterStorageSettings.viewStorageAcceleratorSettings.blackoutTimes",
    "automatedDesktopData.virtualCenterProvisioningSettings.virtualCenterStorageSettings.viewStorageAcceleratorSettings.regenerateViewStorageAcceleratorDays",
    "automatedDesktopData.virtualCenterProvisioningSettings.virtualCenterStorageSettings.viewStorageAcceleratorSettings.useViewStorageAccelerator",
    "automatedDesktopData.virtualCenterProvisioningSettings.virtualCenterStorageSettings.viewStorageAcceleratorSettings.viewComposerDiskTypes",
    "automatedDesktopData.vmNamingSettings.namingMethod",
    "automatedDesktopData.vmNamingSettings.patternNamingSettings.maxNumberOfMachines",
    "automatedDesktopData.vmNamingSettings.patternNamingSettings.minNumberOfMachines",
    "automatedDesktopData.vmNamingSettings.patternNamingSettings.namingPattern",
    "automatedDesktopData.vmNamingSettings.patternNamingSettings.numberOfSpareMachines",
    "automatedDesktopData.vmNamingSettings.patternNamingSettings.provisioningTime",
    "automatedDesktopData.vmNamingSettings.specificNamingSettings",
    "base.description",
    "base.displayName",
    "base.name",
    "desktopSettings.connectionServerRestrictions",
    "desktopSettings.deleting",
    "desktopSettings.displayProtocolSettings.allowUsersToChooseProtocol",
    "desktopSettings.displayProtocolSettings.defaultDisplayProtocol",
    "desktopSettings.displayProtocolSettings.enableHTMLAccess",
    "desktopSettings.displayProtocolSettings.pcoipDisplaySettings.enableGRIDvGPUs",
    "desktopSettings.displayProtocolSettings.pcoipDisplaySettings.maxNumberOfMonitors",
    "desktopSettings.displayProtocolSettings.pcoipDisplaySettings.maxResolutionOfAnyOneMonitor",
    "desktopSettings.displayProtocolSettings.pcoipDisplaySettings.renderer3D",
    "desktopSettings.displayProtocolSettings.pcoipDisplaySettings.vGPUGridProfile",
    "desktopSettings.displayProtocolSettings.pcoipDisplaySettings.vRamSizeMB",
    "desktopSettings.displayProtocolSettings.supportedDisplayProtocols",
    "desktopSettings.enabled",
    "desktopSettings.flashSettings.quality",
    "desktopSettings.flashSettings.throttling",
    "desktopSettings.logoffSettings.allowMultipleSessionsPerUser",
    "desktopSettings.logoffSettings.allowUsersToResetMachines",
    "desktopSettings.logoffSettings.automaticLogoffMinutes",
    "desktopSettings.logoffSettings.automaticLogoffPolicy",
    "desktopSettings.logoffSettings.deleteOrRefreshMachineAfterLogoff",
    "desktopSettings.logoffSettings.powerPolicy",
    "desktopSettings.logoffSettings.refreshOsDiskAfterLogoff",
    "desktopSettings.logoffSettings.refreshPeriodDaysForReplicaOsDisk",
    "desktopSettings.logoffSettings.refreshThresholdPercentageForReplicaOsDisk",
    "desktopSettings.mirageConfigurationOverrides.enabled",
    "desktopSettings.mirageConfigurationOverrides.overrideGlobalSetting",
    "desktopSettings.mirageConfigurationOverrides.url",
    "globalEntitlementData.globalEntitlement",
    "ManualDesktopData",
    "RdsDesktopData",
    "Source",
    "Type"
)

#endregion Property Lists
return [PSCustomObject]@{
    Servers = $Servers
    ApiList = $ApiList
    CurrentServer = $DefaultServer
    DesktopProperties = $DesktopProperties
}