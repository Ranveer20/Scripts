## PowerShell in Practice
## by Richard Siddaway
## Listing 13.16
## Creating a virtual directory
###################################
md c:\services  
New-WebVirtualDirectory -Site testprov -Application Processes -Name Services -PhysicalPath c:\services

Get-WebVirtualDirectory                                                