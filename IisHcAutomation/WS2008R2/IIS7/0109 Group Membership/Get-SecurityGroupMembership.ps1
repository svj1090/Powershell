<#
    .SYNOPSIS
    This script gets the membership of security groups from one or more computers using the text file .\SecurityGroups.txt.
    .DESCRIPTION
    This script gets the membership of security groups from one or more computers using the text file .\SecurityGroups.txt and writes them to a comma separated file (CSV) for post-analysis such as auto-filter in Microsoft Excel. This script requires remote WMI connectivity to all of the servers specified. WMI uses Remote Procedure Calls (RPC) which uses random network ports. The WMI connections are encrypted when possible.
    .EXAMPLE
    .\Get-SecurityGroupMembership.ps1 -Computers Web01;Web02;Web03
    This will gather the security group membership from Web01, Web02, and Web03 using the credentials you are current logged in with. The output is written to .\SecurityGroupMembership.csv.
    .EXAMPLE
    .\Get-SecurityGroupMembership.ps1 -Computers Web01;Web02;Web03 -User 'contoso\administrator'
    This will gather the security group membership from Web01, Web02, and Web03 using the credentials you specified. This is the recommended way to use different credentials because this will prompt you for a password using a secure prompt. The output is written to .\SecurityGroupMembership.csv.    
    .EXAMPLE
    .\Get-SecurityGroupMembership.ps1 -Computers Web01;Web02;Web03 -User 'contoso\administrator' -Password 'LetMeIn123' -OutputCsvFilePath 'C:\SecurityGroupMembership.csv'
    This will gather the security group membership from Web01, Web02, and Web03 using the credentials passed in (optional) and write the output to C:\SecurityGroupMembership.csv. The default output location is the local directory. Avoid providing the password via command line. Consider omitting the password for a secure prompt.
    .Parameter Computers
    This parameters requires a string of computer names separated by semi-colons (;) or a single computer name. If omitted, then the local computer name is used.
    .Parameter User
    A user account that has administrator privileges to all of the target computers. If omitted, then your currently logged in credentials are used. You cannot change your credentials when targeting the local computer.
    .Parameter Password
    The password of the user account specified. If a user account is specified, then a password is required. You can specify the password as a string argument to this script or omit the password to get a secure prompt.
    .Parameter OutputCsvFilePath
    The file path to a comma separated value (CSV) file to write the output to. If omitted, then .\SecurityGroupMembership.csv is used.
	.Parameter SecurityGroupDomain
	This is the computer (for local security groups) or the domain name of the security group.
	.Parameter SecurityGroupName
	This is the name of the security group to target.
    .Notes
    Name: Get-SecurityGroupMembership.ps1
    Author: Clint Huffman (clinth@microsoft.com)
    LastEdit: November 25th, 2011
    Keywords: PowerShell, WMI, IIS7, security, NTFS
#>
param([string]$Computers="$env:computername",[string]$User='',[string]$Password='',[string]$OutputCsvFilePath="$(Split-Path -parent $MyInvocation.MyCommand.Definition)\Get-SecurityGroupMembership.csv",[string]$SecurityGroupName='')

#// Argument processing
$global:Computers = $Computers
$global:User = $User
$global:Password = $Password
$global:SecurityGroupFilePath = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)\SecurityGroups.txt"


If ($SecurityGroupName -ne '')
{
	$global:aSecurityGroupName = @($SecurityGroupName)	
}
Else
{
	If ($(Test-Path -Path $global:SecurityGroupFilePath) -eq $true)
	{
		$global:aSecurityGroupName = @(Get-Content -Path $global:SecurityGroupFilePath)
	}
	Else
	{
		Write-Error 'No security group name or .\SecurityGroups.txt provided.'
		Break;
	}
}


Function ProcessArguments
{    
    $global:aComputers = $global:Computers.Split(';')
    If ($global:aComputers -isnot [System.String[]])
    {
        $global:aComputers = @($global:Computers)
    }
    
    #// If credentials are passed into this script, then make them secure.
    If ($global:User -ne '')
    {        
        If ($global:Password -ne '')
        {
            $global:Password = ConvertTo-SecureString -AsPlainText -Force -String $global:Password
            $global:oCredential = New-Object System.Management.Automation.PsCredential($global:User,$global:Password)            
        }
        Else
        {
            $global:oCredential = Get-Credential -Credential $global:User
        }  
    }
}

Function Start-Timer
{
    $global:dBeginTime = Get-Date
}

Function Stop-Timer
{
    param($BeginTime=$global:dBeginTime)
    $dEndTime = Get-Date
	#$dDurationTime = New-TimeSpan -Start $BeginTime -End $dEndTime
    New-TimeSpan -Start $BeginTime -End $dEndTime
	#Write-Host "`t[$dDurationTime] $Title"	
}

Function Start-GlobalTimer
{
    $global:dGlobalBeginTime = Get-Date   
}

Function Stop-GlobalTimer
{
    $dGlobalEndTime = Get-Date
	$dDurationTime = New-TimeSpan -Start $global:dGlobalBeginTime -End $dGlobalEndTime
	"`nScript Execution Duration: " + $dDurationTime + "`n"
}

Function WriteTo-Csv
{
    param($Line)
    $Line | Out-File -FilePath $global:oOutputFile -Encoding 'ASCII' -Append
}

Function Get-WmiQuery
{
    param($Namespace='root\cimv2',$Query,$Computer)
    
    If ($global:User -ne '')
    {
        Get-WmiObject -Namespace $Namespace -Query $Query -ComputerName $Computer -Authentication 6 -Credential $global:oCredential
    }
    Else
    {
        Get-WmiObject -Namespace $Namespace -Query $Query -ComputerName $Computer -Authentication 6
    }
}

Function Get-WmiIis7Query
{
    param($Namespace='root\WebAdministration',$Query,$Computer)
    Get-WmiQuery -Namespace 'root\WebAdministration' -Query $Query -Computer $Computer
}

$global:LastComputerEnvCollected = ''

Function Expand-EnvironmentVariables
{
    param($Computer,$String)
    $String = $String.ToLower()
    $sWql = 'SELECT Name, VariableValue FROM Win32_Environment'
    If ($global:LastComputerEnvCollected -ne $Computer)
    {
        $dBeginTime = Get-Date
        Write-Host "Getting environment variables from $Computer..." -NoNewline
        $global:oCollectionOfEnvironmentVariables = Get-WmiQuery -Query $sWql -Computer $Computer
        $dDuration = Stop-Timer -BeginTime $dBeginTime
        Write-Host "Done! [$dDuration]"
    }
    ForEach ($oEnv in $global:oCollectionOfEnvironmentVariables)
    {
        $sEnv = '%' + "$($oEnv.Name)" + '%'
        $sValue = "$($oEnv.VariableValue)"
        $String = $String.Replace($sEnv,$sValue)
    }
    If ($($String.IndexOf('%')) -ge 0)
    {
        #// Some environment variables like %SystemRoot% must be manually looked up.
        If ($global:LastComputerEnvCollected -ne $Computer)
        {
            $sWql = 'SELECT SystemDrive, SystemDirectory, WindowsDirectory FROM Win32_OperatingSystem'
            $global:oCollectionOfOperatingSystems = Get-WmiQuery -Query $sWql -Computer $Computer
            $global:LastComputerEnvCollected = $Computer
        }
        
        $String = $String.ToLower()

        ForEach ($oEnv in $global:oCollectionOfOperatingSystems)
        {
            $sValue = "$($oEnv.WindowsDirectory)"
            $String = $String.Replace('%systemroot%',$sValue)
            $String = $String.Replace('%windir%',$sValue)
            
            $sValue = "$($oEnv.SystemDrive)"
            $String = $String.Replace('%systemdrive%',$sValue)
            
            $sValue = "$($oEnv.SystemDirectory)"
            $String = $String.Replace('%systemdirectory%',$sValue)            
        }
        
        If ($($String.IndexOf('%')) -ge 0)
        {
            Write-Warning 'Unable to resolve one or more of the environment variables in the following string:'
            Write-Host "$String"
        }
    }
    $String
}

Function Parse-CustomGroupMembershipOutput
{
	param([string]$WmiString)
	#// \\SOLRING\root\cimv2:Win32_Group.Domain="REDMOND",Name="InfoSec Secure Environment"
	$aSplitByComma = $WmiString.Split(',')
	[string] $sValue = ''
	For ($i=0;$i -lt $aSplitByComma.Count;$i++)
	{
		$aSplitByEqual = $aSplitByComma[$i].Split('=')
		$iUpperBound = $aSplitByEqual.GetUpperBound(0)
		$sTemp = $aSplitByEqual[$iUpperBound]
		$sTemp = $sTemp -replace '"',''
		If ($i -eq 0)
		{
			$sValue = $sTemp
		}
		Else
		{
			$sValue = "$sValue" + '\' + $sTemp
		}
	}
	$sValue
}

Function Main
{
    $global:oOutputFile = New-Item -Path $OutputCsvFilePath -ItemType 'file' -Force
    WriteTo-Csv 'Computer,SecurityGroupDomain,SecurityGroupName,AccountDomain,AccountName'
	$aSecurityGroupObjects = @()
    ForEach ($sComputer in $global:aComputers)
    {
        Write-Host ''
        Start-Timer
        Write-Host "Getting security group membership from $sComputer..." -NoNewline
		
		ForEach ($sSecurityGroupToQuery in $global:aSecurityGroupName)
		{
			$aSecurityGroupToQuery = $sSecurityGroupToQuery.Split('\')
			
			If ($($aSecurityGroupToQuery[0].ToUpper()) -eq 'BUILTIN')
			{
				$sSecurityGroupDomainToQuery = $sComputer
			}
			Else
			{
				$sSecurityGroupDomainToQuery = $aSecurityGroupToQuery[0]
			}
			
	        #// Enumerate each web site and virtual directory for file paths
			#SELECT * FROM Win32_GroupUser WHERE GroupComponent="Win32_Group.Domain=\"solring\",Name=\"Administrators\""
			$sWmiQuery = 'SELECT PartComponent FROM Win32_GroupUser WHERE GroupComponent="Win32_Group.Domain=\"' + "$($sSecurityGroupDomainToQuery)" + '\",Name=\"' + "$($aSecurityGroupToQuery[1])" + '\""'
			$oWmiCollection = Get-WmiQuery -Query $sWmiQuery -Computer $sComputer | SELECT PartComponent
			
			#// Parse the output string :: // \\SOLRING\root\cimv2:Win32_Group.Domain="REDMOND",Name="InfoSec Secure Environment"
			
			ForEach ($oWmiInstance in $oWmiCollection)
			{
				[string] $sMemberDomainAndName = Parse-CustomGroupMembershipOutput -WmiString $oWmiInstance.PartComponent
				$aMemberDomainAndName = $sMemberDomainAndName.Split('\')
				$oSecurityObject = New-Object pscustomobject
				Add-Member -InputObject $oSecurityObject -MemberType NoteProperty -Name Computer -Value $sComputer
				Add-Member -InputObject $oSecurityObject -MemberType NoteProperty -Name GroupDomain -Value $($aSecurityGroupToQuery[0])
				Add-Member -InputObject $oSecurityObject -MemberType NoteProperty -Name GroupName -Value $($aSecurityGroupToQuery[1])
				Add-Member -InputObject $oSecurityObject -MemberType NoteProperty -Name MemberDomain -Value $($aMemberDomainAndName[0])
				Add-Member -InputObject $oSecurityObject -MemberType NoteProperty -Name MemberName -Value $($aMemberDomainAndName[1])
				$aSecurityGroupObjects += @($oSecurityObject)
				
		        #           'Computer       ,     SecurityGroupDomain             ,     SecurityGroupName             ,    AcountDomain                            ,    AccountName'
		        #$sCsvLine = "$sComputer" + ',' + "$global:SecurityGroupDomain" + ',' + "$global:aSecurityGroupName" + ',' + "$($aSecurityGroupDomainAndName[0])" + ',' + "$($aSecurityGroupDomainAndName[1])"
		        #WriteTo-Csv -Line $sCsvLine			
			}		
		}
		$dDuration = Stop-Timer
		Write-Host "Done! [$dDuration]"
    }
	$aSecurityGroupObjects | Format-Table -AutoSize
	$aSecurityGroupObjects | Export-Csv -Path $OutputCsvFilePath -NoTypeInformation
}

Start-GlobalTimer
ProcessArguments
Main
Stop-GlobalTimer

Write-Host "Output written to $OutputCsvFilePath"
Write-Host 'Done!'
Write-Host ''








