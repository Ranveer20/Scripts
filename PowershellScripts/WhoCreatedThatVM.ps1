cls

#User variables
$vCenter = "vCenter"	#vCenter name
# Start Date to look for VI Events.  
# This matches the log retention policy in vCenter that I have for tasks and events
$startDate = (Get-Date).AddDays(-90)
$report = @()
$date = Get-Date -Format "yyyy-MM-dd"
$output_file = "C:\VMswithNoCreatedBy-$date.csv"

# Uncomment the next line to test this script and tell you what it would do !
# $WhatIfPreference = $true
if (-not (Get-PSSnapin VMware.VimAutomation.Core -ErrorAction SilentlyContinue)) {
    Add-PSSnapin VMware.VimAutomation.Core
}
if (-not (Get-PSSnapin Quest.ActiveRoles.ADManagement -ErrorAction SilentlyContinue)) {
    Add-PSSnapin Quest.ActiveRoles.ADManagement
}

#Start of script
# Connect to vCenter and squelch CN Warnings [saves setting, changes it to silent, connects, changes setting back ]
$wpref = $WarningPreference
$WarningPreference="SilentlyContinue"
if (!$DefaultVIServer){ connect-viserver $vCenter }
$WarningPreference = $wpref

$VMs = Get-VM | Sort Name

# Check to ensure "CreatedBy" and "CreatedOn" fields exist in vCenter.  
# If not, create them
$VM = $VMs | Select -First 1
If (-not $vm.CustomFields.ContainsKey("CreatedBy")) {
	Write-Host "Creating CreatedBy Custom field for all VM's"
	New-CustomAttribute -TargetType VirtualMachine -Name CreatedBy | Out-Null
}
If (-not $vm.CustomFields.ContainsKey("CreatedOn")) {
	Write-Host "Creating CreatedOn Custom field for all VM's"
	New-CustomAttribute -TargetType VirtualMachine -Name CreatedOn | Out-Null
}

#Start running through every VM
Foreach ($VM in $VMs){
	If ($vm.CustomFields["CreatedBy"] -eq $null -or $vm.CustomFields["CreatedBy"] -eq ""){
		Write-Host "Finding creator for $vm"
		# Adjust max samples if you want to look through even more logs.  If not specified, default is 100
		$Event = $VM | Get-VIEvent -Types Info -Start $startDate  | Where { $_.Gettype().Name -eq "VmBeingDeployedEvent" -or $_.Gettype().Name -eq "VmCreatedEvent" -or $_.Gettype().Name -eq "VmRegisteredEvent" -or $_.Gettype().Name -eq "VmClonedEvent"}
		If (($Event | Measure-Object).Count -eq 0){
			#Save the name to the CSV
			$row = "" | Select VM
			$row.VM = $VM.Name
			$report += $row
			
			$User = "Unknown"
			# Check the AD Object for the creation time and uses that instead
			# This is because we don't know when the VM was created
			$Computer = Get-QADComputer -Identity $VM.Name | where {$_.name -eq $VM.Name}
            if ($Computer) { $Created = $Computer.WhenCreated.ToString()}
            else { $Created = "Unknown" }
		} Else {
			If ($Event.Username -eq "" -or $Event.Username -eq $null) {
				$User = "Unknown"
			} Else {
				$User = (Get-QADUser -Identity $Event.Username).DisplayName
				if ($User -eq $null -or $User -eq ""){
					$User = $Event.Username
				}
			}
			$Created = $Event.CreatedTime
		}
		Write "Adding info to $($VM.Name)"
		Write-Host -ForegroundColor Blue "CreatedBy $User"
		$VM | Set-Annotation -CustomAttribute "CreatedBy" -Value $User -Confirm:$false | Out-Null
		Write-Host -ForegroundColor Blue "CreatedOn $Created"
		$VM | Set-Annotation -CustomAttribute "CreatedOn" -Value $Created -Confirm:$false | Out-Null
	}
}

$report | Export-Csv $output_file -NoTypeInformation
Invoke-Item $output_file

#Close out your connection
Disconnect-VIServer -Server $vCenter -Confirm:$false