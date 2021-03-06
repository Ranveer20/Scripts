## PowerShell in Practice
## by Richard Siddaway
## Listing 13.3
## Create a site with WMI
#################################
$Site = [WMIClass]'root\webadministration:Site'

$Binding = [WMIClass]'root\webadministration:BindingElement'

$BInstance = $Binding.CreateInstance() 

$Binstance.BindingInformation = "*:80:testwmi.manticore.org"

$BInstance.Protocol = "http"  

$Site.Create('TestWMI', $Binstance, 'C:\Inetpub\TestWMI', $true)