<#
    Ref: https://docs.microsoft.com/en-us/powershell/module/webadministration/clear-webconfiguration?view=windowsserver2019-ps

    Def: 'Clear-WebConfiguration' can be used to remove various settings from a site, in this example was used to remove "powered by" header
#>

$Website = "Website"
$PSPath =  'MACHINE/WEBROOT/APPHOST/' + $Website

$iis = new-object Microsoft.Web.Administration.ServerManager
$config = $iis.GetWebConfiguration($Website)
$httpProtocolSection = $config.GetSection("system.webServer/httpProtocol")
$headers = $httpProtocolSection.GetCollection("customHeaders")
Clear-WebConfiguration "/system.webServer/httpProtocol/customHeaders/add[@name='X-Powered-By']"