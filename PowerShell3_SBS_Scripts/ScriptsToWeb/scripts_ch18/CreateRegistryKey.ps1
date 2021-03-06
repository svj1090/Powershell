# -----------------------------------------------------------------------------
# CreateRegistryKey.ps1
# ed wilson, msft, 4/2/2012
# creates a registry key
# Windows PowerShell 3.0 Step by Step
# ----------------------------------------
Function Add-RegistryValue($key,$value)
{
 $scriptRoot = "HKCU:\software\ForScripting"
 if(-not (Test-Path -path $scriptRoot))
   { 
    New-Item -Path HKCU:\Software\ForScripting | Out-null 
    New-ItemProperty -Path $scriptRoot -Name $key -Value $value `
    -PropertyType String | Out-Null
    }
  Else
  {
   Set-ItemProperty -Path $scriptRoot -Name $key -Value $value | `
   Out-Null
  }
  
} #end function Add-RegistryValue

# *** Entry Point to Script ***
Add-RegistryValue -key forscripting -value test