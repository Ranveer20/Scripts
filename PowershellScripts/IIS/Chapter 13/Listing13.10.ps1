## PowerShell in Practice
## by Richard Siddaway
## Listing 13.10
## Create application pool
###################################
New-WebAppPool -Name wmipool  

cd IIS:\AppPools
ls
New-Item netpool  
cd \
cd c:
