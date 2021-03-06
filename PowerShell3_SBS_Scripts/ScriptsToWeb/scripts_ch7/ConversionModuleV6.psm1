Function ConvertTo-MetersPerSecond
{
 <#
  .Synopsis
    Converts Miles per Hour into Meters per second.  
   .Example
    ConvertTo-MetersPerSecond -MilesPerHour 55
    Converts 55 miles per hour into meters per second
   .Parameter MilesPerHour
    The Miles per hour to be converted to Meters per Second
   .Inputs
    [double]
   .Outputs
    [psobject]
   .Notes
    NAME:  ConvertTo-MetersPerSecond
    AUTHOR: Ed Wilson
    AUTHOR BOOK: Windows PowerShell 2.0 Best Practices, Microsoft Press 2010
    LASTEDIT: 1/31/2010
    KEYWORDS: WeekEnd Scripter, Modules, Getting Started
   .Link
     Http://www.ScriptingGuys.com
     Http://www.bit.ly/HSGBlog
 #>
 #Requires -Version 2.0
[CmdletBinding()]
 param(
      [Parameter(Mandatory = $True,valueFromPipeline=$true)]
      [Double]
      $MilesPerHour
) #end param

if($MilesPerHour)
  {
   $outObject = New-Object psobject -property @{
        value = ($milesPerHour * 0.44704) ;
        units = "Meters per sec"
   }
   $outObject
  }
} #end function ConvertTo-MetersPerSecond

Function ConvertTo-Liters
{
 <#
  .Synopsis
    Converts Cubic Centimeters, Cubic feet, Gallons, Pints, Quarts into Liters
   .Description
    The ConvertTo-Liters function will accept an input in 
    Cubic Centimeters, Cubic feet, Gallons, Pints, Quarts and convert to Liters.
   .Example
    ConvertTo-Liters -cCentimeter 100
    Converts 100 cubic centimeters into liters
   .Example
    ConvertTo-Liters -cFeet 10
    Converts 10 cubic feet into liters
   .Example
    ConvertTo-Liters -Gallon 1
    Converts 1 gallon into liters
   .Example
    ConvertTo-Liters -pint 5
    Converts 5 pints into liters
   .Example
    ConvertTo-Liters -quart 5
    Converts 5 quarts into liters
   .Parameter cCentimeter
    The number of cubic centimeters to be converted
   .Parameter cFeet
    The number of cubic feet to be converted
   .Parameter Gallon
    The number of gallons to be converted
   .Parameter Pint
    The number of pints to be converted
   .Parameter Quart
    The number of quarts to be converted
   .Inputs
    [double]
   .Outputs
    [psobject]
   .Notes
    NAME:  ConvertTo-Liters
    AUTHOR: Ed Wilson
    AUTHOR BOOK: Windows PowerShell 2.0 Best Practices, Microsoft Press 2010
    LASTEDIT: 2/9/2010
    KEYWORDS: WeekEnd Scripter, Modules, Getting Started
   .Link
     Http://www.ScriptingGuys.com
     Http://www.bit.ly/HSGBlog
 #>
 #Requires -Version 2.0
 [CmdletBinding()]
 param(
      [Parameter(Mandatory = $false,valueFromPipeline=$true)]
      [Double]
      $cCentimeter,
      [Parameter(Mandatory = $false,valueFromPipeline=$true)]
      [Double]
      $cFeet,
      [Parameter(Mandatory = $false,valueFromPipeline=$true)]
      [Double]
      $Gallon,
      [Parameter(Mandatory = $false,valueFromPipeline=$true)]
      [Double]
      $Quart,
      [Parameter(Mandatory = $false,valueFromPipeline=$true)]
      [Double]
      $Pint          
) #end param

  If($cCentimeter) 
    { 
        $outObject = New-Object psobject -property @{
        value = ($cCentimeter * [math]::pow(10,-3)) ;
        units = "liters" }
        $outObject
    }
  If($cFeet) 
    { 
        $outObject = New-Object psobject -property @{
        value = ($cFeet * 28.316) ;
        units = "liters" }
        $outObject
    }
  If($Gallon) 
    { 
        $outObject = New-Object psobject -property @{
        value = ($Gallon * 3.7853) ;
        units = "liters" }
   $outObject
    }
  If($Quart) 
    { 
        $outObject = New-Object psobject -property @{
        value = ($Quart * 0.94633) ;
        units = "liters" }
   $outObject
    }
   If($Pint) 
    { 
       $outObject = New-Object psobject -property @{
        value = ($Pint * 0.47316) ;
        units = "liters" }
   $outObject
    }
} #end ConvertTo-Liters

Function ConvertTo-Pounds
{
 <#
  .Synopsis
    Converts tons, ounces, kilograms or metricTons into pounds
   .Description
    The ConvertTo-Pounds function will accept an input in 
    tons, ounces, kilograms or metricTons and convert the result into pounds.
   .Example
    ConvertTo-Pounds -ton 1
    Converts 1 ton into pounds
   .Example
    ConvertTo-Pounds -ounce 1000
    Converts 1000 ounces into pounds
   .Example
    ConvertTo-Pounds -kilogram 1
    Converts 1 kilograms into pounds
   .Example
    ConvertTo-Pounds -metricTon 1
    Converts 1 metricTon into pounds
   .Parameter ton
    The number of tons to be converted
   .Parameter ounce
    The number of ounces to be converted
   .Parameter kilogram
    The number of kilograms to be converted
   .Parameter metricTon
    The number of metricTons to be converted
   .Inputs
    [double]
   .Outputs
    [psobject]
   .Notes
    NAME:  ConvertTo-Pounds
    AUTHOR: Ed Wilson
    AUTHOR BOOK: Windows PowerShell 2.0 Best Practices, Microsoft Press 2010
    LASTEDIT: 1/31/2010
    KEYWORDS: WeekEnd Scripter, Modules, Getting Started
   .Link
     Http://www.ScriptingGuys.com
     Http://www.bit.ly/HSGBlog
 #>
 #Requires -Version 2.0
 [CmdletBinding()]
 param(
      [Parameter(Mandatory = $false,valueFromPipeline=$true)]
      [Double]
      $Ton,
      [Parameter(Mandatory = $false,valueFromPipeline=$true)]
      [Double]
      $Ounce,
      [Parameter(Mandatory = $false,valueFromPipeline=$true)]
      [Double]
      $KiloGram,
      [Parameter(Mandatory = $false,valueFromPipeline=$true)]
      [Double]
      $MetricTon     
) #end param
  If($ton) 
    { 
       $outObject = New-Object psobject -property @{
        value = ($ton * 2000) ;
        units = "pounds" }
   $outObject
    }
  If($ounce) 
    { 
       $outObject = New-Object psobject -property @{
        value = ($ounce * 0.0625) ;
        units = "pounds" }
   $outObject
    }
  If($kilogram) 
    { 
       $outObject = New-Object psobject -property @{
        value = ($kilogram * 2.205) ;
        units = "pounds" }
   $outObject
    }
  If($metricTon) 
    { 
       $outObject = New-Object psobject -property @{
        value = ($metricTon * 2205) ;
        units = "pounds" }
   $outObject
    }
} #end ConvertTo-Pounds

Function ConvertTo-Meters
{
 <#
  .Synopsis
    Converts feet into meters
   .Description
    The ConvertTo-Meters function accepts a value in feet and 
    returns a string indicating the number of meters.
   .Example
    ConvertTo-Meters 1
    Converts 1 foot into meters
   .Parameter feet
    The number of feet to be converted
   .Inputs
    [double]
   .Outputs
    [psobject]
   .Notes
    NAME:  ConvertTo-Meters
    AUTHOR: Ed Wilson
    AUTHOR BOOK: Windows PowerShell 2.0 Best Practices, Microsoft Press 2010
    LASTEDIT: 1/31/2010
    KEYWORDS: WeekEnd Scripter, Modules, Getting Started
   .Link
     Http://www.ScriptingGuys.com
     Http://www.bit.ly/HSGBlog
 #Requires -Version 2.0
 #>
 [CmdletBinding()]
 param(
      [Parameter(Mandatory = $true,Position = 0,valueFromPipeline=$true)]
      [Double]
      $feet
) #end param
     $outObject = New-Object psobject -property @{
        value = ($feet*.31) ;
        units = "meters" }
   $outObject
} #end ConvertTo-Meters

Function ConvertTo-Feet
{
 <#
  .Synopsis
    Converts meters into feet
  .Description
    The ConvertTo-Feet function accepts a value in meters and 
    returns a string indicating the number of feet.
   .Example
    ConvertTo-Feet 1
    Converts 1 meter into feet
   .Parameter meters
    The number of meters to be converted into feet
   .Inputs
    [double]
   .Outputs
    [psobject]
   .Notes
    NAME:  ConvertTo-Feet
    AUTHOR: Ed Wilson
    LASTEDIT: 1/31/2010
    KEYWORDS: WeekEnd Scripter, Modules, Getting Started
   .Link
     Http://www.ScriptingGuys.com
 #Requires -Version 2.0
 #>
 [CmdletBinding()]
 param(
      [Parameter(Mandatory = $true,Position = 0,valueFromPipeline=$true)]
      [Double]
      $meters
) #end param
    $outObject = New-Object psobject -property @{
        value = ($meters * 3.28) ;
        units = "feet" }
   $outObject
} #end ConvertTo-Feet

Function ConvertTo-Fahrenheit
{
 <#
  .Synopsis
    Converts celsius into fahrenheit
  .Description
    The ConvertTo-Fahrenheit function accepts a value in celsius and 
    returns a string indicating the temperature in Fahrenheit.
   .Example
    ConvertTo-Fahrenheit 1
    Converts 1 degree celsius into fahrenheit
   .Parameter celsius
    The  temperature to be converted into fahrenheit
   .Inputs
    [double]
   .Outputs
    [psobject]
   .Notes
    NAME:  ConvertTo-Fahrenheit
    AUTHOR: Ed Wilson
    LASTEDIT: 1/31/2010
    KEYWORDS: WeekEnd Scripter, Modules, Getting Started
   .Link
     Http://www.ScriptingGuys.com
 #Requires -Version 2.0
 #>
 [CmdletBinding()]
 param(
      [Parameter(Mandatory = $true,Position = 0,valueFromPipeline=$true)]
      [Double]
      $celsius
) #end param
   $outObject = New-Object psobject -property @{
        value = ((1.8 * $celsius) + 32) ;
        units = "fahrenheit" }
   $outObject
} #end ConvertTo-Fahrenheit

Function ConvertTo-celsius
{
 <#
  .Synopsis
    Converts fahrenheit into celsius
  .Description
    The ConvertTo-Celsius function accepts a value in fahrenheit and 
    returns a string indicating the temperature in celsius.
   .Example
    ConvertTo-Celsius 1
    Converts 1 degree fahrenheit into celsius
   .Parameter fahrenheit
    The  temperature to be converted
   .Inputs
    [double]
   .Outputs
    [psobject]
   .Notes
    NAME:  ConvertTo-Celsius
    AUTHOR: Ed Wilson
    LASTEDIT: 1/31/2010
    KEYWORDS: WeekEnd Scripter, Modules, Getting Started
   .Link
     Http://www.ScriptingGuys.com
 #Requires -Version 2.0
 #>
 [CmdletBinding()]
 param(
      [Parameter(Mandatory = $true,Position = 0,valueFromPipeline=$true)]
      [Double]
      $fahrenheit
) #end param
   $outObject = New-Object psobject -property @{
        value = ((($fahrenheit - 32)/9)*5) ;
        units = "celsius" }
   $outObject
} #end ConvertT-ocelsius

Function ConvertTo-Miles
{
 <#
  .Synopsis
    Converts kilometers into miles
  .Description
    The ConvertTo-Miles function accepts a value in kilometers and 
    returns a string indicating the distance in miles.
   .Example
    ConvertTo-Miles
    Converts 1 kilometer into miles
   .Parameter kilometer
    The distance to be converted
   .Inputs
    [double]
   .Outputs
    [psobject]
   .Notes
    NAME:  ConvertTo-Miles
    AUTHOR: Ed Wilson
    LASTEDIT: 1/31/2010
    KEYWORDS: WeekEnd Scripter, Modules, Getting Started
   .Link
     Http://www.ScriptingGuys.com
 #Requires -Version 2.0
 #>
 [CmdletBinding()]
 param(
      [Parameter(Mandatory = $true,Position = 0,valueFromPipeline=$true)]
      [Double]
      $kilometer
) #end param
    $outObject = New-Object psobject -property @{
        value = ($kilometer *.6211) ;
        units = "miles" }
   $outObject
} #end convertToMiles

Function ConvertTo-Kilometers
{
 <#
  .Synopsis
    Converts miles into Kilometers
  .Description
    The ConvertTo-Kilometers function accepts a value in miles and 
    returns a string indicating the distance in kilometers.
   .Example
    ConvertTo-Kilometers 1
    Converts 1 mile into kilometers
   .Parameter miles
    The distance to be converted
   .Inputs
    [double]
   .Outputs
    [psobject]
   .Notes
    NAME:  ConvertTo-Kilometers
    AUTHOR: Ed Wilson
    LASTEDIT: 1/31/2010
    KEYWORDS: WeekEnd Scripter, Modules, Getting Started
   .Link
     Http://www.ScriptingGuys.com
 #Requires -Version 2.0
 #>
 [CmdletBinding()]
 param(
      [Parameter(Mandatory = $true,Position = 0,valueFromPipeline=$true)]
      [Double]
      $miles
) #end param
   $outObject = New-Object psobject -property @{
        value = ($miles * 1.61) ;
        units = "kilometers" }
   $outObject
} #end convertTo-Kilometers

New-Alias -Name CTCS -Value ConvertTo-Celsius -Description "Conversion module alias"
New-Alias -Name CTFH -Value ConvertTo-Fahrenheit -Description "Conversion module alias"
New-Alias -Name CTFT -Value ConvertTo-Feet -Description "Conversion module alias"
New-Alias -Name CTKM -Value ConvertTo-Kilometers -Description "Conversion module alias"
New-Alias -Name CTLT -Value ConvertTo-Liters -Description "Conversion module alias"
New-Alias -Name CTMT -Value ConvertTo-Meters -Description "Conversion module alias"
New-Alias -Name CTMS -Value ConvertTo-MetersPerSecond -Description "Conversion module alias"
New-Alias -Name CTML -Value ConvertTo-Miles -Description "Conversion module alias"
New-Alias -Name CTPD -Value ConvertTo-Pounds -Description "Conversion module alias"

Export-ModuleMember -alias * -function *