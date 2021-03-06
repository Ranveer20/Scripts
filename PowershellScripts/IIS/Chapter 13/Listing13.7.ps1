## PowerShell in Practice
## by Richard Siddaway
## Listing 13.7
## Working remotely with
## PowerShell and IIS
###################################
$sweb01 = New-PSSession -ComputerName web01   

Invoke-Command -Session $sweb01 -ScriptBlock {C:\Users\Richard\Documents\WindowsPowerShell\profile.ps1} 

Invoke-Command -Session $s -ScriptBlock {Add-PSSnapin webadministration}

Invoke-Command -Session $sweb01 -ScriptBlock {Get-PSSnapin}

Invoke-Command -Session $sweb01 -ScriptBlock {Get-WebSite | Format-Table}

Invoke-Command -Session $sweb01 -ScriptBlock {Get-ChildItem iis:\AppPools | Format-Table}  