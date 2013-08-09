## PowerShell in Practice
## by Richard Siddaway
## Listing 13.12
## Modify a site configuration
###################################
Get-ChildItem iis:\AppPools

Set-ItemProperty -Path iis:\Sites\testwmi -Name ApplicationPool -Value wmipool

Get-ChildItem iis:\AppPools