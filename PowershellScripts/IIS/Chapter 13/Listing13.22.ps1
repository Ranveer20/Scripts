## PowerShell in Practice
## by Richard Siddaway
## Listing 13.22
## Modify a configuration file
###################################
Get-WebConfiguration -Filter system.webServer/security/authentication/*[@enabled] -PSPath iis:\ | select ItemXPath,enabled | Format-Table -AutoSize  

Get-WebConfiguration -Filter system.webServer/security/authentication/*[@enabled] -PSPath iis:\sites\testprov | select ItemXPath,enabled | Format-Table -AutoSize  

Get-WebConfiguration -Filter system.webServer/security/authentication/*[@enabled] | Get-Member 

Set-WebConfiguration -Filter system.webServer/security/authentication/basicAuthentication -Value @{enabled="True"} -PSPath iis:\                                 