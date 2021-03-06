# AUTHOR - IAN MANNING
# PURPOSE - part of Councillor casework management

#  CHeck list of cases for no action within a defined time period
# Assumptions:
# Runs against a list of folders, within each folder looks for a file actions.txt
#this file should have date,action as the first line
# subsequent lines should be dates in ISO format ie yyyy-mm-dd
#Update 2018-02-18 - extra error check for Get-Content failures


[CmdletBinding()]
Param(
  [Parameter(Mandatory=$True,Position=1)]
   [int]$inactionTimeDays
)

# the length of inaction to check for
#$inactionTimeDays = 28
# today
$today = Get-Date

# Logfile
$strLogFilePath =".\ActiveCaseslog.csv"
If (Test-Path $strLogFilePath ) {
	}
Else {
	New-Item -ItemType File -Path $strLogFilePath
	Add-Content -Path $strLogFilePath -Value ("Date,Time,NumberOfOutstandingCases,InactionDays,TotalActiveCases")
}

#get folders, filter out 000 folder and Dummy Folder
$allFolders = Get-Childitem | ? { $_.PSIsContainer -eq $true }
$caseWorkFolders = $allFolders  | ? { $_.Name.SubString(0,3) -ne "000" -and $_.Name -ne "DummyFolder" }

# Now loop through each folder and check the last line of the action file for a date that is older than $inactionTimeDays ago

Foreach ( $folder in $caseWorkFolders ) {
    $actionfilepath = Get-Childitem $folder | ? { $_.Name -eq "actions.txt" }
	Try {
    $actionFile = Get-Content $actionfilepath.FullName
    }
	Catch { Write-Host ("Error accessing actionfile in " + $folder) -BackgroundColor White -ForegroundColor Magenta }
	$lastline = $actionFile[$actionFile.Length - 1]
	Try {
    $updateDate = Get-Date ( $lastline.split(",")[0] )
	}
	Catch { Write-Host ("Error parsing date in " + $folder) -BackgroundColor White -ForegroundColor Magenta }
    
        If ( ($today - $updateDate).Days -gt $inactionTimeDays ) {
            Write-Host "You need to update:  " + $folder.Name
            $count++
        }
         
        Else {}      

}

Write-Host ("Checking for cases not updated for " + $inactionTimeDays + " days..................") -ForegroundColor Red -BackgroundColor White  
If (!$count) {
	Write-Host ("==========================================") -ForegroundColor Green -BackgroundColor Black
	Write-Host ("==========================================") -ForegroundColor Green -BackgroundColor Black
	Write-Host ("No cases needing updating - WELL DONE!!!!!") -ForegroundColor GReen -BackgroundColor Black
	Write-Host ("Total cases == " + $caseWorkFolders.Count+"!") -ForegroundColor GReen -BackgroundColor Black
	Write-Host ("==========================================") -ForegroundColor Green -BackgroundColor Black
	Write-Host ("==========================================") -ForegroundColor Green -BackgroundColor Black
	Add-Content -Path $strLogFilePath -Value ( (Get-Date -Format yyyyMMdd) + "," + ( Get-Date -Format HHmm ) + "," + "0" + "," + $inactionTimeDays )
	}
Else {
	Write-Host ("There are " + $count + " cases needing updating - CRACK ON MANNING!!!!") -ForegroundColor Red -BackgroundColor White
	Write-Host ("Total number of active cases: " + $caseWorkFolders.Count) -ForegroundColor Red -BackgroundColor White
	Add-Content -Path $strLogFilePath -Value ( (Get-Date -Format yyyyMMdd) + "," + ( Get-Date -Format HHmm ) + "," + $count + "," + $inactionTimeDays + "," + $caseWorkFolders.count )
}