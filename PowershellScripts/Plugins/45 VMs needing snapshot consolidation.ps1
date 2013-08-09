﻿$Title = "VMs needing snapshot consolidation"
$Header =  "VMs needing snapshot consolidation"
$Comments = "The following VMs have snapshots that failed to consolidate. See <a href='http://blogs.vmware.com/vsphere/2011/08/consolidate-snapshots.html' target='_blank'>this article</a> for more details"
$Display = "Table"
$Author = "Luc Dekens"
$Version = 1.0

# Start of Settings 
# End of Settings 

$VM | where {$_.VMHost.ApiVersion.Split('.')[0] -ge 5 -and $_.ExtensionData.Runtime.consolidationNeeded} | 
Sort-Object -Property Name | 
Select Name,@{N="Consolidation needed";E={$_.ExtensionData.Runtime.consolidationNeeded}}

