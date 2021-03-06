
$location =Read-Host "Enter the location"
$affecting = Read-Host "Enter the name or names this affects, or Anon for proactive or Mass for multiple people reporting."
$issue = Read-Host "Please enter a short description of the issue"
$actionone = Read-Host "Enter initial actions / way issue was picked up"
$date = (Get-Date -Format yyyyMMdd).ToString()

$list = Get-ChildItem | ? { $_.PSIsContainer -eq $true } | Sort-Object Name | Select-Object Name

function Pause ($Message="Press any key to continue...")
{
Write-Host -NoNewLine $Message
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
Write-Host ""
}

$string = $list[$list.Count - 2] 
$casenumber = [int]$string.Name.ToString().Substring(0,3)  + 1
If ( $casenumber.ToString().Length -ne 3 ) {
    $casenumber = "0" + $casenumber.ToString() }
Else {
    $casenumber = $casenumber.ToString()
}

Write-Host ("=============Creating case " + $casenumber + "========================") -ForegroundColor Red -BackgroundColor White
Write-Host ("=============Creating case " + $casenumber + "========================") -ForegroundColor Red -BackgroundColor White
Write-Host ("=============Creating case " + $casenumber + "========================") -ForegroundColor Red -BackgroundColor White

$foldername = $casenumber + "_" + $date + "_" + $location + "_" + $affecting + "_" + $issue

New-Item -ItemType Directory -Path ( $foldername )
cd $foldername
New-Item -ItemType File -Name actions.txt
Add-Content -Path actions.txt -Value "date,action"
Add-Content -Path actions.txt -Value ((Get-Date -Format yyyy-MM-dd).ToString() + "," +  $actionone)
Write-Host "******************Issue created******************" -BackgroundColor Red -ForegroundColor Yellow
cd..
Pause