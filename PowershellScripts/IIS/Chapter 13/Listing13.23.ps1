## PowerShell in Practice
## by Richard Siddaway
## Listing 13.23
## Creating a web page
###################################
Get-Process | ConvertTo-Html -As TABLE | Out-File -FilePath t2.html