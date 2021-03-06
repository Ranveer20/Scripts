## PowerShell in Practice
## by Richard Siddaway
## Listing 13.9
## Controlling websites
###################################
Get-Website
Stop-Website -Name testwmi 
Get-Website

Get-Website | where{$_.state -eq "Stopped"}
Get-Website | where{$_.state -eq "Stopped"} | Start-Website 
Get-Website

Restart-WebItem -PSPath iis:\sites\TestNet
Get-ChildItem iis:\sites | Restart-WebItem 