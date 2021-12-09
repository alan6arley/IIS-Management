<#
    1. Install WebAdministration to interact with IIS
    2. Enable site preload
    3. Set site pool to alwaysrunning and autostart
#>

Import-Module WebAdministration
Install-WindowsFeature Web-AppInit

$AppPoolName = 'WebsitePoolName'
$SiteName = 'Website'

set-itemproperty IIS:\Sites\$SiteName -name applicationDefaults.preloadEnabled -value True

$AppPool = Get-Item IIS:\AppPools\$AppPoolName
$AppPool.startMode = "alwaysrunning"
$AppPool.autoStart = $True
$AppPool.processModel.idleTimeout = [TimeSpan]::FromMinutes(1440)
$AppPool | Set-Item -Verbose