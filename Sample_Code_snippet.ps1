$servers = Get-Content .\servers.txt
$regkey = "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp"
set-itemproperty -path $regkey -name MinEncryptionLevel -value 3 

# Run on your management machine/machine you are using to update all others...
$computers = @("vlpmwebqa","vlpmwebqa2","vlpmqa","vlpmqa2")
foreach ($computer in $computers) {
    Enter-PSSession $computer
    cd 'HKLM:\Software\Microsoft\Windows NT\CurrentVersion'
    Set-ItemProperty -Path . -Name "MinEncryptionLevel" -Value "High"
    Exit-PSSession
}

foreach ($i in 'servers.txt') { Enable-PSRemoting -Force }



psexec "\\vlpmwebqa2" -u admins4v89kr -p Scif@123 -h -d powershell.exe "enable-psremoting -force"
That's it. Twiddle your thumbs for a couple minutes - enable-psremoting can sometimes take a while and the -d modifier just lets it happen in the background on the target remote machine, then you are good to go with all your psRemoting funtimes.
You can also replace "\\[computer name]" with an ip address, or even "@C:\[path]\list.txt to 









Enter / Exit-PSSession is mainly aimed at interactive use. If you want to run this kind of thing against multiple servers you�ll find it better to run Invoke-Command. By default this will run against 32 servers concurrently, e.g.
Invoke-Command -ComputerName �Server1?,�Server2?,�Server3? -ScriptBlock {$path = �HKLM:\Software\Microsoft\Windows NT\CurrentVersion�;Set-ItemProperty -Path $path -Name �RegisteredOwner� -Value �Auth User�;Set-ItemProperty -Path $path -Name �RegisteredOrganization� -Value �Lab�}


get-childitem -Path d:\scripts �recurse | where-object {$_.lastwritetime -gt (get-date).addDays(-1)}


get-childitem C:\CVVPart\OFOS\ | Where-Object { $_.LastWriteTime -lt (get-date).Addminutes(15)}

lastwritetime -gt (get-date).addDays(-1)}


dir C:\PURGE -recurse | 
where { ((get-date)-$_.creationTime).days -gt 15 } | 
remove-item -force

$Directory | where { ((get-date)-$_.creationTime).Minutes -lt 60 }



Remove-Item -Path C:\CVVPart\OFOS\ -Exclude 'Publishedwebsites'





C:\CVVPart\OFOS\OFOS_1.1.28\_PublishedWebsites