## PowerShell in Practice
## by Richard Siddaway
## Listing 13.17
## Remove a web application
###################################
Remove-WebVirtualDirectory –Site testprov –Application processes –Name services

Remove-WebApplication –Site testprov –Name processes