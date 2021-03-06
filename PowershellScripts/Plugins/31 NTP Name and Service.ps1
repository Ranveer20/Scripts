$Title = "NTP Name and Service"
$Header =  "NTP Issues"
$Comments = "The following hosts do not have the correct NTP settings and may cause issues if the time becomes far apart from the vCenter/Domain or other hosts"
$Display = "Table"
$Author = "Alan Renouf"
$Version = 1.0

# Start of Settings 
# The NTP server which should be set on your hosts
$ntpserver ="pool.ntp.org|pool2.ntp.org"
# End of Settings

@($VMH | Where {$_.Connectionstate -ne "Disconnected"} | Select Name, @{N="NTPServer";E={$_ | Get-VMHostNtpServer}}, @{N="ServiceRunning";E={(Get-VmHostService -VMHost $_ | Where-Object {$_.key -eq "ntpd"}).Running}} | Where {$_.ServiceRunning -eq $false -or $_.NTPServer -notmatch $ntpserver})
