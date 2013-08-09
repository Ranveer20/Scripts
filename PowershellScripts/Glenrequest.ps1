﻿@"
===============================================================================
Title:        VMInfo.ps1
Description:   Exports VM Information from vCenter into a .CSV file for importing into anything
Usage:         .\VMInfo.ps1
===============================================================================
"@

$date = Get-Date

filter Get-FolderPath {
    $_ | Get-View | % {
        $row = "" | select Name, Path
        $row.Name = $_.Name
 
        $current = Get-View $_.Parent
#        $path = $_.Name # Uncomment out this line if you do want the VM Name to appear at the end of the path
        $path = ""
        do {
            $parent = $current
            if($parent.Name -ne "vm"){$path = $parent.Name + "\" + $path}
            $current = Get-View $current.Parent
        } while ($current.Parent -ne $null)
        $row.Path = $path
        $row
    }
}
 
$file = "VMInfo" + $date + ".csv"

$ExportFilePath = "C:\Ultimo VMinfo.csv"  
 
$Report = @()
$VMs = Get-VM
 
 
ForEach ($VM in $VMs) {
      $VMView = $VM | Get-View
      $VMInfo = {} | Select VMName,OS,ManagedBy,Folder,powerstate
      $VMInfo.VMName = $vm.name
	  $VMInfo.ManagedBy = ($VM | Get-Annotation -CustomAttribute "Managed By" | select Value)
      $VMInfo.OS = $vm.Guest.OSFullName
      $VMInfo.Folder = ($vm | Get-Folderpath).Path
	  $powerstate = $VM.PowerState
      $Report += $VMInfo
}
$Report = $Report + $date | Sort-Object VMName
IF ($Report -ne "") {
$report | Export-Csv $ExportFilePath -NoTypeInformation
}
