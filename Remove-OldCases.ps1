# Move and folders ending in predefined text to a defined subfolder of the current folder

$subfolder = ".\000_ClosedCases"
$closedend = "_C"

If ( (Test-Path $subfolder) -eq $false) {
    Write-Host "Someone deleted the subfolder or you are running this from the wrong directory:  there should be a folder called " + $subfolder + " in here...quitting"
    Exit
    }
Else {}

$folderends= Get-ChildItem | ? { ($_.Name.ToString().SubString($_.Name.Length -2)) -eq $closedend }

If (!$folderends -eq $true) {
    Write-Host "No cases to archive!  Quitting...."
    Exit
    }
Else {}

$folderends | % { $counter++; Move-Item -Path $_.FullName -Destination $subfolder -Force -Confirm:$false }

If (!$counter -eq $true ) {
    Write-Host "No cases found to archive"
    }
Else {
    Write-Host "Archived " + $counter + " cases."
}
    
   