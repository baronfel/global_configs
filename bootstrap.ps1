iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))

# git stuff
choco install git-credential-winstore
choco install git.install
choco install poshgit
choco install sourcetree

# text editors
choco install sublimetext3
choco install sublimetext3.packagecontrol

# terminal
choco install conemu

# dev tools
choco install atom
choco install fiddler4
choco install firefox-dev -pres
choco install google-chrome-x64
choco install hipchat
choco install linqpad4
choco install mongovue
choco install nodejs.install
choco install nuget.commandline
choco install nugetpackageexplorer
choco install robomongo
choco install windirstat

choco install visualstudio2015enterprise -version 14.0.23107.0

write-host "don't forget to create symlinks, and edit your PATH!"
write-host "and also go get MongoChef!"
