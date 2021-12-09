<#
    Ref: https://docs.microsoft.com/en-us/previous-versions/aspnet/zhhddkxy(v=vs.100)
#>

# Use this for a site or application
cmd /c "%windir%\Microsoft.NET\Framework\v4.0.30319\aspnet_regiis.exe -pe connectionStrings -app /SiteName"

# If you've removed the "default web site" or renamed it, you must specify site 1
#cmd /c "%windir%\Microsoft.NET\Framework\v4.0.30319\aspnet_regiis.exe -pe connectionStrings -app / -site 1"