Push-Location (Split-Path -Path $MyInvocation.MyCommand.Definition -Parent)
# ALIASES
Set-Alias subl "C:\Program Files\Sublime Text 3\sublime_text.exe"
Set-Alias g git
Set-Alias fsi "C:\Program Files (x86)\Microsoft SDKs\F#\4.0\Framework\v4.0\Fsi.exe"

function which($name)
{
    Get-Command $name | Select-Object -ExpandProperty Definition
}

function deploy(){
	param($project, $version, [string[]]$envs)
	foreach($env in $envs){
		octo deploy-release --apikey=$env:OctoAPI --server=http://mozupus.corp.volusion.com --project=$project --version=$version --deployTo=$env
	}
}

function tfbuild(){
	param(
		$server = $env:TFSServer,
		$collection = "vNext",
		$project = "v2Mozu",
		$build, 
		$branch="master", 
		[switch]$stable)
& 'C:\Program Files (x86)\Microsoft Visual Studio 14.0\Common7\IDE\tfsbuild.exe' start $server/$collection $project $build /msBuildArguments:"/p:BranchOverride=$branch;Stable=$stable;"
}
function update(){
    param([string[]]$ids)
    if(Test-Path .nuget){
        $sln = get-childitem "*.sln"
        nuget restore $sln
        foreach($id in $ids){
            nuget update $sln -Id $id
        }
    }
    else{
        .paket\paket.bootstrapper.exe
        foreach($id in $ids){
            .paket\paket update nuget $id
        }
    }
}
# END ALIASES
# PATH
$env:path += ";" + (Get-Item "Env:ProgramFiles").Value + "\Git\bin;"
$env:path += ";" + (Get-Item "Env:ProgramFiles").Value + "\Git\usr\bin;"
$env:path += ";C:\code\global_configs\scripts;"
$env:path += ";$env:MONGOPATH;"
# END PATH
#GIT STUFF
# MODULES
if(Test-Path Function:\Prompt) {Rename-Item Function:\Prompt PrePoshGitPrompt -Force}
. 'C:\tools\poshgit\dahlbyk-posh-git-fadc4dd\profile.example.ps1'
# customize colors for git since the blue background makes red hard to see
# these set the prompt colors
$GitPromptSettings.WorkingForegroundColor = [ConsoleColor]::Red
#END GIT STUFF
# Set up a simple prompt, adding the git prompt parts inside git repos
function global:prompt {
    $realLASTEXITCODE = $LASTEXITCODE
    # Reset color, which can be messed up by Enable-GitColors
    $Host.UI.RawUI.ForegroundColor = $GitPromptSettings.DefaultForegroundColor
    Write-Host($pwd.ProviderPath) -nonewline
    Write-VcsStatus
    $global:LASTEXITCODE = $realLASTEXITCODE
    return "> "
}
Start-SSHAgent -Quiet
Pop-Location
Rename-Item Function:\Prompt PoshGitPrompt -Force
function Prompt() {if(Test-Path Function:\PrePoshGitPrompt){++$global:poshScope; New-Item function:\script:Write-host -value "param([object] `$object, `$backgroundColor, `$foregroundColor, [switch] `$nonewline) " -Force | Out-Null;$private:p = PrePoshGitPrompt; if(--$global:poshScope -eq 0) {Remove-Item function:\Write-Host -Force}}PoshGitPrompt}
