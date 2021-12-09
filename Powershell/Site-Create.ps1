<#
    Def: Create IIS site with or without hostname
#>

# 1. With hostname

$iisWebsiteName = "booztme"
$physicalPath = "C:\sites\booztme"
# Base domain name (no www required)
$url = "acmecharities.com"

# Creates the initial website
New-WebSite -Name $iisWebsiteName `
 -PhysicalPath $physicalPath `
 -IPAddress "*"`
 -Port 80 `
 -HostHeader "$url"

# Adds an additional binding for www
New-WebBinding -Name $iisWebsiteName `
 -IPAddress "*" `
 -Port 80 `
 -protocol http `
 -HostHeader "www.$url"



# 2. Without hostname

$iisWebsiteName = "booztme"
$physicalPath = "C:\sites\booztme"

# This command creates the website binding
New-WebSite -Name $iisWebsiteName -Port 80 -PhysicalPath $physicalPath 