$mongopath = $env:MONGOPATH
$rootPath = "C:\mongoDB"
$dbPath = "$rootPath\data"
$port = 27017
$engine = "wiredTiger"
$logPath = "$rootPath\logs\log.log"
&"$mongopath\mongod.exe" --port $port --dbpath $dbPath --storageEngine $engine --directoryperdb | Tee-Object -FilePath $logPath
