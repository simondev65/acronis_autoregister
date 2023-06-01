$exe=$Env:Programfiles"\BackupClient\RegisterAgentTool\register_agent.exe"
$exe = $exe -replace ' ','` '
$exe="'$exe' -o unregister"
Write-Output $exe
