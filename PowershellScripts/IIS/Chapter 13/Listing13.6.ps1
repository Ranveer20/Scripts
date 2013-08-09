## PowerShell in Practice
## by Richard Siddaway
## Listing 13.6
## Create a site with
## the IIS provider
###################################
cd IIS:\sites

New-Item testprov -bindings @{protocol="http";bindingInformation=":80:testprov.manticore.org"} -physicalPath c:\inetpub\testprov

cd \
cd c: