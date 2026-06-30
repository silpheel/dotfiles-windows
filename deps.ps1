# Check to see if we are currently running "as Administrator"
if (!(Verify-Elevated)) {
   $newProcess = new-object System.Diagnostics.ProcessStartInfo "PowerShell";
   $newProcess.Arguments = $myInvocation.MyCommand.Definition;
   $newProcess.Verb = "runas";
   [System.Diagnostics.Process]::Start($newProcess);

   exit
}

# system and cli
winget install Microsoft.WebPICmd                        --silent --accept-package-agreements --accept-source-agreements
winget install Git.Git                                   --silent --accept-package-agreements --accept-source-agreements --override "/VerySilent /NoRestart /o:PathOption=CmdTools /Components=""icons,assoc,assoc_sh,gitlfs"""
winget install --id=GitHub.GitHubDesktop -e
winget install OpenJS.NodeJS                             --silent --accept-package-agreements --accept-source-agreements
winget install Python.Python.3.12                        --silent --accept-package-agreements --accept-source-agreements
winget install RubyInstallerTeam.Ruby.3.2                --silent --accept-package-agreements --accept-source-agreements
winget install OpenSSH                                   --silent --accept-package-agreements --accept-source-agreements
New-NetFirewallRule -Name "OpenSSH Server (sshd)" -DisplayName "OpenSSH Server (sshd)" -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22

# browsers
winget install Waterfox.Waterfox                         --silent --accept-package-agreements --accept-source-agreements

# dev tools and frameworks
winget install Microsoft.PowerShell                      --silent --accept-package-agreements --accept-source-agreements
Microsoft.VisualStudio.Workload.Azure --add Microsoft.VisualStudio.Workload.NetWeb"
winget install Vim.Vim                                   --silent --accept-package-agreements --accept-source-agreements
winget install VSCodium.VSCodium                         --silent --accept-package-agreements --accept-source-agreements
winget install Microsoft.Sysinternals.ProcessExplorer    --silent --accept-package-agreements --accept-source-agreements
winget install Microsoft.PowerToys                       --silent --accept-package-agreements --accept-source-agreements
winget install AntibodySoftware.Wiztree                  --silent --accept-package-agreements --accept-source-agreements
winget install CrystalDewWorld.CrystalDiskInfo           --silent --accept-package-agreements --accept-source-agreements
winget install Oracle.MySQLWorkbench                     --silent --accept-package-agreements --accept-source-agreements
winget install SamHocevar.WinCompose                     --silent --accept-package-agreements --accept-source-agreements
winget install CrystalDewWorld.CrystalDiskMark           --silent --accept-package-agreements --accept-source-agreements
winget install alexx2000.DoubleCommander                 --silent --accept-package-agreements --accept-source-agreements

# Other
winget install -e --id LizardByte.Sunshine
winget install --id=BillStewart.SyncthingWindowsSetup -e
winget install --id=ZhornSoftware.Caffeine -e
winget install --id=Microsoft.PowerToys -e
winget install --id=Microsoft.WindowsTerminal -e
winget install --id=Rufus.Rufus -e
winget install --id=Python.Python.3.12 -e
winget install --id=Starship.Starship -e
winget install --id=Oracle.MySQLWorkbench -e
winget install --id=CaddyServer.Caddy -e
winget install --id=NSSM.NSSM -e
winget install -e --id Apple.iCloud

Refresh-Environment

gem pristine --all --env-shebang
Get-ChildItem 'C:\Program Files\Vim\' -Filter "vim*" -ErrorAction SilentlyContinue | Select-Object -First 1 | ForEach-Object {Append-EnvPath $_.FullName}

### Node Packages
Write-Host "Installing Node Packages..." -ForegroundColor "Yellow"
if (which npm) {
    npm update npm
    npm install -g yo
}

### Janus for vim
Write-Host "Installing Janus..." -ForegroundColor "Yellow"
if ((which curl) -and (which vim) -and (which rake) -and (which bash)) {
    curl.exe -L https://bit.ly/janus-bootstrap | bash

    cd ~/.vim/
    git submodule update --remote
}

