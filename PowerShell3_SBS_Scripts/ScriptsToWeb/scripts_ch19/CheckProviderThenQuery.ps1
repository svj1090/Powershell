# -----------------------------------------------------------------------------
# Script: CheckProviderThenQuery.ps1
# Author: ed wilson, msft
# Date: 04/22/2012 16:45:24
# Keywords: Scripting Techniques, Error Handling
# comments: 
# PowerShell 3.0 Step-by-Step, Microsoft Press, 2012
# Chapter 19
# -----------------------------------------------------------------------------
If(Get-WmiObject -Class __provider -filter "name = 'cimwin32'")
 {
  Get-WmiObject -class Win32_bios
 }
Else
 {
  "Unable to query Win32_Bios because the provider is missing"
 } 
