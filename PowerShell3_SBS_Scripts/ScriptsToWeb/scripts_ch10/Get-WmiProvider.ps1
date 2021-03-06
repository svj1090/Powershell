Function Get-WmiProvider
{
 Param(
  $nameSpace = "root\cimv2",
  $computer = "localhost"
 )
  Get-WmiObject -class __Provider -namespace $namespace | 
  Sort-Object -property Name | 
  Select-Object name
} #end function Get-WmiProvider
