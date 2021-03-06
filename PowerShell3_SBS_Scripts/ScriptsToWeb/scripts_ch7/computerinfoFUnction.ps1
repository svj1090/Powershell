Function Get-ComputerInfo
{
 <#
  .Synopsis
    Retrieves basic information about a computer. 
   .Description
    The Get-ComputerInfo cmdlet retrieves basic information such as
    computer name, domain name, and currently logged on user from
    a local or remote computer.
   .Example
    Get-ComputerInfo 
    Returns comptuer name, domain name and currently logged on user
    from local computer.
    .Example
    Get-ComputerInfo -computer berlin
    Returns comptuer name, domain name and currently logged on user
    from remote computer named berlin.
   .Parameter Computer
    Name of remote computer to retrieve information from
   .Inputs
    [string]
   .OutPuts
    [object]
   .Notes
    NAME:  Get-ComputerInfo
    AUTHOR: Ed Wilson
    LASTEDIT: 6/30/2012
    KEYWORDS: Desktop mgmt, basic information
   .Link
     Http://www.ScriptingGuys.com
 #Requires -Version 2.0
 #>
 Param([string]$computer=$env:COMPUTERNAME)
 $wmi = Get-WmiObject -Class win32_computersystem -ComputerName $computer
 $pcinfo = New-Object psobject -Property @{"host" = $wmi.DNSHostname
           "domain" = $wmi.Domain 
           "user" = $wmi.Username}
 $pcInfo
} #end function Get-ComputerInfo
