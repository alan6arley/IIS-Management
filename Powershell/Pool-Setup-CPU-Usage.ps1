<#
    Ref: https://docs.microsoft.com/en-us/dotnet/api/microsoft.web.administration.applicationpool.cpu?view=iis-dotnet
#>

$AppPoolName = "AcmeWeb"

if(Test-Path IIS:\AppPools\$AppPoolName)
{
    $appPool = Get-Item IIS:\AppPools\$AppPoolName
    $appPool.cpu.limit = 10000
    $appPool.cpu.action = 'ThrottleUnderLoad'
    $appPool.cpu.resetInterval = '00:01:00'
    $appPool | Set-Item
}
else
{
  Write-Host "Application Pool" $AppPoolName "does not exist"
}