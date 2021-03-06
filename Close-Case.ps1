[CmdletBinding()]
Param(
  [Parameter(Mandatory=$True,Position=1)]
   [string]$casefolder,
  [Parameter(Mandatory=$True,Position=2)]
   [string]$closereason
)

$archivedir = ".\000_ClosedCases"

$f = Get-Item $casefolder
cd $f
Add-Content -Path actions.txt -Value "`n"
Add-Content -Path actions.txt -Value ((Get-Date -Format yyyy-MM-dd).ToString() + "," +  $closereason + " CASE CLOSED")
cd ..
Rename-Item -Path $f.FullName -NewName ( $f.FullName + "_C" )

Move-Item -Path ( $f.FullName + "_C" ) -Destination $archivedir

Write-Host "==========================" -ForegroundColor Red -BackgroundColor Yellow
Write-Host ("Case " + $f.Name.SubString(0,3) + " marked as closed.") -ForegroundColor DarkRed -BackgroundColor Yellow
Write-Host "==========================" -ForegroundColor Red -BackgroundColor Yellow
