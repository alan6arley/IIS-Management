<#
    Ref: https://docs.microsoft.com/en-us/dotnet/api/microsoft.web.administration.applicationpool.processmodel?view=iis-dotnet
         https://docs.microsoft.com/en-us/dotnet/api/microsoft.web.administration.applicationpoolprocessmodel?view=iis-dotnet
#>

$AppPoolName = "AcmeWeb"

if(Test-Path IIS:\AppPools\$AppPoolName)
{
    #Process
    $AppPool.processModel.idleTimeout = '00:10:00'
    $AppPool.processModel.idleTimeoutAction = 'Terminate'

    $AppPool.processModel.maxProcesses = 1

    $AppPool.processModel.pingingEnabled = $true
    $AppPool.processModel.pingInterval = 30
    $AppPool.processModel.pingResponseTime = '00:00:30'

    $AppPool.processModel.startupTimeLimit = '00:00:30'
    $AppPool.processModel.shutdownTimeLimit = '00:00:30'
    $appPool | Set-Item
}
else
{
  Write-Host "Application Pool" $AppPoolName "does not exist"
}