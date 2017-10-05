# Horizon Management 
This is a module meant to build basic cmdlets on top of the Horizon View API. Dependent upon having the PowerCli Modules loaded with the Horizon View sub module

# Quick Start
. <ModuleFolder>\install.ps1
Import-Module HorizonManagement

Connect-HvServerList -Server 'myserver.company.com'

Get-DesktopPool -Name 'My Pool'

# AutoCompletion and Current Server
Almost all of the parameters in this module should autocomplete based on the "Current" HV server, which can be changed with the Set-CurrentHVServer cmdlet
The Starting Current Sever can be specified in the config.ps1 file

# Contributers guide
WIP
