<#
    Ref: https://docs.microsoft.com/en-us/dotnet/api/microsoft.web.administration.applicationpool?view=iis-dotnet
#>

$AppPoolName = "AcmeWeb"

if(Test-Path IIS:\AppPools\$AppPoolName)
{
    $appPool = Get-Item IIS:\AppPools\$AppPoolName
    $appPool.managedRuntimeVersion = 'v4.0'
    $appPool.autoStart = 'true'
    $appPool.startmode = 'alwaysrunning'
    $appPool.managedPipelineMode = 'Integrated'
    $appPool.queueLength = 50
    $appPool | Set-Item
}
else
{
  Write-Host "Application Pool" $AppPoolName "does not exist"
}