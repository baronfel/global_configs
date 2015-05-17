Push-Location (Split-Path -Path $MyInvocation.MyCommand.Definition -Parent)

# END MODULES
# ALIASES
Set-Alias sublime "C:\Program Files\Sublime Text 3\sublime_text.exe"
Set-Alias g git
Set-Alias many git
Set-Alias much git
Set-Alias such git

# END ALIASES
# PATH
$env:path += ";" + (Get-Item "Env:ProgramFiles(x86)").Value + "\Git\bin"
$env:path += ";C:\mongodb\bin;"
# END PATH

#GIT STUFF
# MODULES
if(Test-Path Function:\Prompt) {Rename-Item Function:\Prompt PrePoshGitPrompt -Force}
. 'C:\tools\poshgit\dahlbyk-posh-git-9d95ed5\profile.example.ps1'

# customize colors for git since the blue background makes red hard to see
# these set the prompt colors
$GitPromptSettings.WorkingForegroundColor = [ConsoleColor]::Red
$GitPromptSettings.UntrackedForeGroundColor = [ConsoleColor]::Red
Enable-GitColors
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
