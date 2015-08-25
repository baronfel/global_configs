$mongopath = $env:MONGOPATH
$rootPath = "C:\mongoDB"
$dbPath = "$rootPath\data"
$port = 27017
$engine = "wiredTiger"
$logPath = "$rootPath\logs\log.log"
&"$mongopath\mongod.exe" --port $port --dbpath $dbPath --directoryperdb | Tee-Object -FilePath $logPath

// took off the --storageEngine param
