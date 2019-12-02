# Check to see if we are currently running "as Administrator"
if (!(Verify-Elevated)) {
   $newProcess = new-object System.Diagnostics.ProcessStartInfo "PowerShell";
   $newProcess.Arguments = $myInvocation.MyCommand.Definition;
   $newProcess.Verb = "runas";
   [System.Diagnostics.Process]::Start($newProcess);

   exit
}


### Update Help for Modules
Write-Host "Updating Help..." -ForegroundColor "Yellow"
Update-Help -Force


### Package Providers
Write-Host "Installing Package Providers..." -ForegroundColor "Yellow"
Get-PackageProvider NuGet -Force | Out-Null
# Chocolatey Provider is not ready yet. Use normal Chocolatey
#Get-PackageProvider Chocolatey -Force
#Set-PackageSource -Name chocolatey -Trusted


### Install PowerShell Modules
Write-Host "Installing PowerShell Modules..." -ForegroundColor "Yellow"
Install-Module Posh-Git -Scope CurrentUser -Force
Install-Module PSWindowsUpdate -Scope CurrentUser -Force


### Chocolatey
Write-Host "Installing Desktop Utilities..." -ForegroundColor "Yellow"
if ((which cinst) -eq $null) {
    iex (new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1')
    Refresh-Environment
    choco feature enable -n=allowGlobalConfirmation
}

# system and cli
choco install curl                --limit-output
choco install nuget.commandline   --limit-output
choco install webpi               --limit-output
choco install git.install         --limit-output -params '"/GitAndUnixToolsOnPath /NoShellIntegration"'
choco install nvm.portable        --limit-output
choco install python3             --limit-output
choco install ruby                --limit-output
choco install github-Desktop      --limit-output

#fonts
choco install sourcecodepro       --limit-output

# browsers
#choco install GoogleChrome        --limit-output; <# pin; evergreen #> choco pin add --name GoogleChrome        --limit-output
#choco install GoogleChrome.Canary --limit-output; <# pin; evergreen #> choco pin add --name GoogleChrome.Canary --limit-output
choco install Firefox             --limit-output; <# pin; evergreen #> choco pin add --name Firefox             --limit-output
#choco install Opera               --limit-output; <# pin; evergreen #> choco pin add --name Opera               --limit-output

# dev tools and frameworks
choco install atom                --limit-output; <# pin; evergreen #> choco pin add --name Atom                --limit-output
choco install Fiddler             --limit-output
choco install vim                 --limit-output
choco install winmerge            --limit-output
choco install notepadplusplus.install --limit-output

# system functionality extenders
choco install 7zip                --limit-output
choco install 7zip.install        --limit-output
choco install autohotkey.portable --limit-output
choco install Everything          --limit-output
choco install glasswire           --limit-output
choco install karen               --limit-output
choco install icloud              --limit-output
choco install nircmd              --limit-output
choco install procexp             --limit-output
choco install revo-uninstaller    --limit-output
choco install seer                --limit-output
choco install sharex              --limit-output
choco install switcheroo          --limit-output
choco install switcheroo.install  --limit-output
choco install sysinternals        --limit-output
choco install teracopy            --limit-output
choco install wiztree             --limit-output
choco install freecommander-xe.install --limit-output

# consoles
choco install alacritty           --limit-output
choco install Cmder               --limit-output

# readers
choco install calibre             --limit-output
choco install fsviewer            --limit-output
choco install sumatrapdf          --limit-output
choco install sumatrapdf.commandline --limit-output
choco install mediamonkey         --limit-output

# gaming
choco install epicgameslauncher   --limit-output
choco install goggalaxy           --limit-output
choco install itch                --limit-output
choco install origin              --limit-output
choco install steam               --limit-output
choco install twitch              --limit-output
choco install uplay               --limit-output

# other
choco install audacity            --limit-output
choco install Franz               --limit-output
choco install mkvtoolnix          --limit-output
choco install qbittorrent         --limit-output
choco isntall vlc                 --limit-output

Refresh-Environment

nvm on
$nodeLtsVersion = choco search nodejs-lts --limit-output | ConvertFrom-String -TemplateContent "{Name:package-name}\|{Version:1.11.1}" | Select -ExpandProperty "Version"
nvm install $nodeLtsVersion
nvm use $nodeLtsVersion
Remove-Variable nodeLtsVersion

gem pristine --all --env-shebang

### Windows Features
Write-Host "Installing Windows Features..." -ForegroundColor "Yellow"
# IIS Base Configuration
Enable-WindowsOptionalFeature -Online -All -FeatureName `
    "IIS-BasicAuthentication", `
    "IIS-DefaultDocument", `
    "IIS-DirectoryBrowsing", `
    "IIS-HttpCompressionDynamic", `
    "IIS-HttpCompressionStatic", `
    "IIS-HttpErrors", `
    "IIS-HttpLogging", `
    "IIS-ISAPIExtensions", `
    "IIS-ISAPIFilter", `
    "IIS-ManagementConsole", `
    "IIS-RequestFiltering", `
    "IIS-StaticContent", `
    "IIS-WebSockets", `
    "IIS-WindowsAuthentication" `
    -NoRestart | Out-Null

# ASP.NET Base Configuration
Enable-WindowsOptionalFeature -Online -All -FeatureName `
    "NetFx3", `
    "NetFx4-AdvSrvs", `
    "NetFx4Extended-ASPNET45", `
    "IIS-NetFxExtensibility", `
    "IIS-NetFxExtensibility45", `
    "IIS-ASPNET", `
    "IIS-ASPNET45" `
    -NoRestart | Out-Null

# Web Platform Installer for remaining Windows features
webpicmd /Install /AcceptEula /Products:"UrlRewrite2"

### Node Packages
Write-Host "Installing Node Packages..." -ForegroundColor "Yellow"
if (which npm) {
    npm update npm
    npm install -g gulp
    npm install -g mocha
    npm install -g node-inspector
    npm install -g yo
}

### Janus for vim
Write-Host "Installing Janus..." -ForegroundColor "Yellow"
if ((which curl) -and (which vim) -and (which rake) -and (which bash)) {
    curl.exe -L https://bit.ly/janus-bootstrap | bash
}


### Atom PackageSource
# TODO
