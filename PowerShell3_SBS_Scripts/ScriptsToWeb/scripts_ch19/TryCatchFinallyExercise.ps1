# -----------------------------------------------------------------------------
# Script: TryCatchFinallyExercise.ps1
# Author: ed wilson, msft
# Date: 04/22/2012 18:32:05
# Keywords: exercise 19-2
# comments: solution
# PowerShell 3.0 Step-by-Step, Microsoft Press, 2012
# Chapter 19
# -----------------------------------------------------------------------------
Param(
  [Parameter(Mandatory=$true)]
  $object)
"Beginning test ..."
Try
{
 "`tAttempting to create object $object"
 New-Object $object }
Catch [system.exception]
{ "`tUnable to create $object" }
Finally
 { "Reached the end of the Script" }