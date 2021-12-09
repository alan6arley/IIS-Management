<#
    Ref: https://docs.microsoft.com/en-us/dotnet/api/microsoft.web.administration.applicationpool.recycling?view=iis-dotnet
#>

$AppPoolName = "AcmeWeb"

if(Test-Path IIS:\AppPools\$AppPoolName)
{
    # Option 1
    #$AppPool.recycling.periodicRestart.privateMemory = 120
    #$AppPool.recycling.periodicRestart.memory = 120
    #$AppPool.recycling.periodicRestart.requests = 2000
    #$AppPool.recycling.periodicRestart.time = '2:00:00'
    #$appPool | Set-Item

    # Option 2
    #Set-ItemProperty IIS:\AppPools\$AppPoolName -Name recycling.periodicRestart.schedule `
    #-Value @{value="01:00:00"}

    # Option 3
    #$appPool.recycling.logEventOnRecycle = "Time, Memory, ConfigChange, PrivateMemory"
    #$appPool | Set-Item
}
else
{
  Write-Host "Application Pool" $AppPoolName "does not exist"
}