# NOTE: Almost everything may change according to your needs

$physicalPath = "C:\sites\dev.booztme.com"
$siteName = "Dev booztme"
$hostName = "dev.booztme.com"

## Verify required IIS Configuration

$desiredFeatures = @(
    "Web-Server",
    "Web-WebServer",
    "Web-Common-Http",
    "Web-Default-Doc",
    "Web-Dir-Browsing",
    "Web-Http-Errors",
    "Web-Static-Content",
    "Web-Health",
    "Web-Http-Logging",
    "Web-Performance",
    "Web-Stat-Compression",
    "Web-Security"
    "Web-Filtering",
    "Web-App-Dev",
    "Web-Net-Ext45",
    "Web-Asp-Net45",
    "Web-ISAPI-Ext",
    "Web-ISAPI-Filter",
    "Web-Mgmt-Tools",
    "Web-Mgmt-Console",
    "Web-Mgmt-Service"
)

foreach ($feature in $desiredFeatures){
    if ((Get-WindowsFeature $feature).InstallState -ne "Installed") {
        Write-Host "FAIL - $feature Not Installed" -ForegroundColor Red
        break
    }else {
        Write-Host "PASS - $feature is Installed" -ForegroundColor Green
    }
}


# Check required  artifacts 

if ((Test-Path -Path $physicalPath)) {
    Write-Host "PASS - $physicalPath exists" -ForegroundColor Green
}else {
    Write-host "FAIL - $physicalPath does not exist" -ForegroundColor Red
    Exit
}

$files = @( 
    "ApplicationInsights.config",
    "aspnet_client",
    "bin",
    "Content",
    "favicon.ico",
    "fonts",
    "Global.asax",
    "Scripts",
    "Views",
    "Web.config"
)

foreach ($file in $files) {

    if ((Test-Path -Path $physicalPath\$file)) {
        Write-Host "PASS - $file exists" -ForegroundColor Green
    }else {
        Write-host "FAIL - $file does not exist" -ForegroundColor Red
        Exit
    }
}


#Check site bindings, app. pool, site name, and runtime

$bindings = Get-WebBinding -Name $siteName
if ($bindings.bindingInformation -eq "*:80:$hostName"){
    Write-Host "PASS - Bindings correct for website"  -ForegroundColor Green
}else {
    Write-Host "FAIL - Binding not configured correctly" -ForegroundColor Red
    break
}

if(Test-Path IIS:\AppPools\$siteName){
    Write-Host "PASS - Application pool ($sitename) found" -ForegroundColor Green
}else {
    Write-Host "FAIL - Application Pool not found " -ForegroundColor Red
}

$appPool = Get-ItemProperty "IIS:\AppPools\$siteName" | select *
if ($appPool.Name -eq $siteName){
    Write-Host "PASS - Name is $siteName" -ForegroundColor Green
}else {
    Write-Host "FAIL - Name was expected to be $siteName"
}

if ($appPool.managedRuntimeVersion -eq "v4.0"){
    Write-Host "PASS - Managed Runtime is Correct" -ForegroundColor Green
}else {
    Write-Host "FAIL - Managed Runtime is not 4.0" -ForeGroundColor Red
}