<#
    Ref: https://docs.microsoft.com/en-us/iis/configuration/system.webserver/httpprotocol/customheaders/
         https://docs.microsoft.com/en-us/troubleshoot/iis/add-http-response-header-web-site
    
    Def: Lets you add custom response headers, in this example was used a header to prevent framing
#>

# Set http response headers to prevent framing

$Website = "Website"
$PSPath =  'MACHINE/WEBROOT/APPHOST/' + $Website
  
Remove-WebConfigurationProperty -PSPath $PSPath -Name . -Filter system.webServer/httpProtocol/customHeaders -AtElement @{name =$HeaderName }
             
$iis = new-object Microsoft.Web.Administration.ServerManager
$config = $iis.GetWebConfiguration($WebSiteName) #i.e. "Default Web Site"
$httpProtocolSection = $config.GetSection("system.webServer/httpProtocol")
$headers = $httpProtocolSection.GetCollection("customHeaders")

$addElement = $headers.CreateElement("add")
$addElement["name"] = "X-Frame-Options"  
$addElement["value"] = "SameOrigin"

$customHeadersCollection.Add($addElement)

$iis.CommitChanges() 
write-host $iis