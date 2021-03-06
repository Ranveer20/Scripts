$Title = "Datastore Information"
$Header =  "Datastores (Less than $DatastoreSpace% Free) : $($OutputDatastores.count)"
$Comments = "Datastores which run out of space will cause impact on the virtual machines held on these datastores"
$Display = "Table"
$Author = "Alan Renouf"
$Version = 1.0

# Start of Settings 
# Set the warning threshold for Datastore % Free Space
$DatastoreSpace =50
# End of Settings

$OutputDatastores = @($Datastores | Select Name, Type, CapacityGB, FreeSpaceGB, PercentFree| Sort PercentFree)| Where { $_.PercentFree -lt $DatastoreSpace }
$OutputDatastores
