<#

    STEPS:
    1. Fill variables with your site information
    2. If IIS is installed continue the process, if not, install the role and server
    3. Setup physical path for the site
    4. Check if artifacts folder exists, if not, break the process
    5. Copy artifacts to site physical path, if an error ocurrs, break the process
    6. Create new IIS site with bindings

    NOTE: This example was for an ASP.NET site, so some things may change according to your site's technologies

#>

Import-Module WebAdministration 

# 1. Define variables
$machineName = Hostname
$websiteUrl = "dev.booztme.com"
$iisWebsiteName = "Dev booztme"
$physicalPath = "C:\sites\dev.booztme.com"
$artifactFolder = "C:\artifacts\booztme\Latest"


# 2. Check if IIS is installed
if ((Get-WindowsFeature Web-Server).InstallState -ne "Installed") {
    # You may want to install additional modules here
    Enable-WindowsOptionalFeature -Online -FeatureName IIS-WebServerRole
    Enable-WindowsOptionalFeature -Online -FeatureName IIS-WebServer
}else {
    Write-Host "IIS is installed on $machineName"
}


# 3. Check if website physical path exists
if (!(Test-Path -Path $physicalPath)) {
    # If not create it
    New-Item -Force -ItemType directory -Path $physicalPath
    Write-Host "Site PhysicalPath: $physicalPath was created"
}else {
    Write-Host "Site PhysicalPath: $physicalPath already exists"
}


# 4. Check artifact storage physical path exists
if (!(Test-Path -Path $artifactFolder)) {
    # If not, send a message and exit
    Write-Host "ArtifactFolder: $artifactFolder does not exist"
    Exit
}


# 5. Copy over artifacts
Try{ 
    # We use force here to make sure and overwrite old files
    Copy-item -Force -Recurse $artifactFolder\* -Destination $physicalPath
    Write-Host "Artifacts copied successfully"
}
Catch{
    # If something goes wrong, we'll display the errors and exit
    Write-Host "Artifacs copy failed: $_Exception.Message"
    Exit
}


# 6. Create new IIS site
# Recreate app. pool
if(Test-Path IIS:\AppPools\$iisWebsiteName){
    Remove-WebAppPool -Name $iisWebsiteName
}
New-WebAppPool -Name $iisWebsiteName

# Check if website with this name already exists
if (!(Get-Website -Name $iisWebsiteName)){
    # if not, create with its bindings
    New-WebSite -Name $iisWebsiteName -Port 80 -IPAddress * -HostHeader $websiteUrl -PhysicalPath $physicalPath -ApplicationPool $iisWebsiteName
    Set-ItemProperty "IIS:\Sites\$iisWebsiteName" -Name  Bindings -value @{protocol="http";bindingInformation="*:80:$websiteUrl"}
}

# ---------- ASP.NET Configuration --------------#

# Check if ASP.NET 4.5 is installed
if ((Get-WindowsFeature Web-Asp-Net45).InstallState -ne "Installed") {
    Install-WindowsFeature -Name Web-Asp-Net45
}

# Set the App Pool to the 4.0 runtime
Set-ItemProperty IIS:\AppPools\$iisWebsiteName -Name managedRuntimeVersion -Value "v4.0"