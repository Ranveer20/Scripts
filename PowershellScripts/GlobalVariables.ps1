# You can change the following defaults by altering the below settings:
#

# Set the following to true to enable the setup wizard for first time run
$SetupWizard =$False

# Start of Settings
# Please Specify the IP address or Hostname of the vCenter to connect to
$VIServer ="172.26.40.204"
 Please Specify the SMTP server address
MTPSRV ="smtp.f2.com.au"
# Please specify the email address who will send the vCheck report
$EmailFrom ="jamie.smith@fairfaxdigital.com.au"
# Please specify the email address who will recieve the vCheck report
$EmailTo ="jamie.smith@fairfaxdigital.com.au"
# Would you like the report displayed in the local browser once completed ?
$DisplaytoScreen =$true
# Use the following item to define if an email report should be sent once completed
$SendEmail =$false
# If you would prefer the HTML file as an attachement then enable the following:
$SendAttachment =$true
# Use the following area to define the title color
$Colour1 ="000000"
# Use the following area to define the Heading color
$Colour2 ="7BA7C7"
# Use the following area to define the Title text color
$TitleTxtColour ="FFFFFF"
# End of Settings

# Path to credentials file which is automatically created if needed
$Credfile = $ScriptPath + "\Windowscreds.xml"

# Adding PowerCLI core snapin
if (!(get-pssnapin -name VMware.VimAutomation.Core -erroraction silentlycontinue)) {
	add-pssnapin VMware.VimAutomation.Core
}

Write-CustomOut "Connecting to VI Server"

$VIConnection = Connect-VIServer $VIServer
if (-not $VIConnection.IsConnected) {
	Write-Host "Unable to connect to vCenter, please ensure you have altered the vCenter server address correctly "
	Write-Host " to specify a username and password edit the connection string in the file $GlobalVariables"
	break
}
# Find out which version of the API we are connecting to

$VIVersion = ((Get-View ServiceInstance).Content.About.Version).Chars(0)

$Date = Get-Date

# Check for vSphere
If ($serviceInstance.Client.ServiceContent.About.Version -ge 4){
	$vSphere = $true
}


Write-CustomOut "Adding Custom properties"
New-VIProperty -Name PercentFree -ObjectType Datastore -Value {
	param($ds)
	[math]::Round(((100 * ($ds.FreeSpaceMB)) / ($ds.CapacityMB)),0)
} -Force | Out-Null

New-VIProperty -Name "HWVersion" -ObjectType VirtualMachine -Value {
	param($vm)

	$vm.ExtensionData.Config.Version[5]
} -BasedOnExtensionProperty "Config.Version" -Force | Out-Null

Write-CustomOut "Collecting VM Objects"
$VM = Get-VM | Sort Name
Write-CustomOut "Collecting VM Host Objects"
$VMH = Get-VMHost | Sort Name
Write-CustomOut "Collecting Cluster Objects"
$Clusters = Get-Cluster | Sort Name
Write-CustomOut "Collecting Datastore Objects"
$Datastores = Get-Datastore | Sort Name
Write-CustomOut "Collecting Detailed VM Objects"
$FullVM = Get-View -ViewType VirtualMachine | Where {-not $_.Config.Template}
Write-CustomOut "Collecting Template Objects"
$VMTmpl = Get-Template
Write-CustomOut "Collecting Detailed VI Objects"
$ServiceInstance = get-view ServiceInstance
Write-CustomOut "Collecting Detailed Alarm Objects"
$alarmMgr = get-view $serviceInstance.Content.alarmManager
Write-CustomOut "Collecting Detailed VMHost Objects"
$HostsViews = Get-View -ViewType hostsystem
Write-CustomOut "Collecting Detailed Cluster Objects"
$clusviews = Get-View -ViewType ClusterComputeResource
Write-CustomOut "Collecting Detailed Datastore Objects"
$storageviews = $Datastores |Get-View
