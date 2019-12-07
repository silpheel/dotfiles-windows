# Profile for the Microsoft.Powershell Shell, only. (Not Visual Studio or other PoSh instances)
# ===========
echo "Booting MS profile"
Push-Location (Split-Path -parent $profile)
"components-shell","components","functions","aliases","exports","extra" | Where-Object {Test-Path "$_.ps1"} | ForEach-Object -process {Invoke-Expression ". .\$_.ps1"}
Pop-Location
