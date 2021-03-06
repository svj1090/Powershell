$help = Get-Content "C:\Users\s4v89kr\Desktop\ALL_DESKTOP\Test-Port.ps1" | Select-Object -First 10

<#
.SYNOPSIS

You can execute the script with 3 parameters 
the first one is called "InputFile" which will contain the list of accounts you want to add
the second one is called "Computer" to which your specified accounts will be added 
the third one is called "Trustee" which can read the group or account name from PS console rather than including them in InputFile.

#>


param(
    [Parameter(ParameterSetName='InputFile')]
    [string]
        $InputFile,
    [Parameter(ParameterSetName='Computer')]
    [string]
        $Computer,
    [string]
        $Trustee
)
<#
.SYNOPSIS
    Function that resolves SAMAccount and can exit script if resolution fails
#>
function Resolve-SamAccount {
param(
    [string]
        $SamAccount,
    [boolean]
        $Exit
)
    process {
        try
        {
            $ADResolve = ([adsisearcher]"(samaccountname=$Trustee)").findone().properties['samaccountname']
        }
        catch
        {
            $ADResolve = $null
        }

        if (!$ADResolve) {
            Write-Warning "User `'$SamAccount`' not found in AD, please input correct SAM Account"
            if ($Exit) {
                exit
            }
        }
        $ADResolve
    }
}

if (!$Trustee) {
    $Trustee = Read-Host "Please input trustee"
}

if ($Trustee -notmatch '\\') {
    $ADResolved = (Resolve-SamAccount -SamAccount $Trustee -Exit:$true)
    $Trustee = 'WinNT://',"$env:userdomain",'/',$ADResolved -join ''
} else {
    $ADResolved = ($Trustee -split '\\')[1]
    $DomainResolved = ($Trustee -split '\\')[0]
    $Trustee = 'WinNT://',$DomainResolved,'/',$ADResolved -join ''
}

if (!$InputFile) {
	if (!$Computer) {
		$Computer = Read-Host "Please input computer name"
	}
	[string[]]$Computer = $Computer.Split(',')
	$Computer | ForEach-Object {
		$_
		Write-Host "Adding `'$ADResolved`' to Administrators group on `'$_`'"
		try {
			([ADSI]"WinNT://$_/Administrators,group").add($Trustee)
			Write-Host -ForegroundColor Green "Successfully completed command for `'$ADResolved`' on `'$_`'"
		} catch {
			Write-Warning "$_"
		}	
	}
}
else {
	if (!(Test-Path -Path $InputFile)) {
		Write-Warning "Input file not found, please enter correct path"
		exit
	}
	Get-Content -Path $InputFile | ForEach-Object {
		Write-Host "Adding `'$ADResolved`' to Administrators group on `'$_`'"
		try {
			([ADSI]"WinNT://$_/Administrators,group").add($Trustee)
			Write-Host -ForegroundColor Green "Successfully completed command"
		} catch {
			Write-Warning "$_"
		}        
	}
}