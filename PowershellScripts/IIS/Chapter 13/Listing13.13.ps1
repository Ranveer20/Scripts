## PowerShell in Practice
## by Richard Siddaway
## Listing 13.13
## Remove website
###################################
Remove-WebSite -Name testnet  
Remove-WebAppPool -Name netpool 

Remove-Item iis:\Sites\testwmi 
Remove-Item iis:\AppPools\wmipool