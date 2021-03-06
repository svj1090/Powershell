
#+-------------------------------------------------------------------+  
#| = : = : = : = : = : = : = : = : = : = : = : = : = : = : = : = : = |  
#|{>/-------------------------------------------------------------\<}|           
#|: | Author:  Aman Dhally                                        | :|           
#| :| Email:   amandhally@gmail.com
#|: | Purpose: Ping Multiple Servers / Computers     
#|: |                    Date: 15-Nov-2011        
#| :| 	/^(o.o)^\    	 Version: 1        						  |: | 
#|{>\-------------------------------------------------------------/<}|
#| = : = : = : = : = : = : = : = : = : = : = : = : = : = : = : = : = |
#+-------------------------------------------------------------------+


#### Provide the computer name in $computername variable

$ServerName = "Dc-2","LocalHost","Server-2","Not-Exists", "Fake-computer", "Dc-1" 

##### Script Starts Here ###### 

foreach ($Server in $ServerName) {

		if (test-Connection -ComputerName $Server -Count 2 -Quiet ) { 
		
			write-Host "$Server is alive and Pinging " -ForegroundColor Green
		
					} else
					
					{ Write-Warning "$Server seems dead not pinging"
			
					}	
		
}


########## end of script #######################