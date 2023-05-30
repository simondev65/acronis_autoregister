
$h=hostname

write-output "Setting up Acronis Agent. Please dont close this window, it should take a few seconds"

write-output "***credential***  if you want to register to acronis, create a token and enter url and token in %parent%\token.txt"

write-output 'FYI your computername is:' $h
write-output '*** IF you want to change the hostname you can change it afterwards in windows settings***'

$projectType=Get-ProjectType
write-output $projectType
break

Function Get-ProjectType {
    $type=Read-Host "
    1 - unregister Acronis agent
    2 - Register acronis Agent with a new UUID
    3 - exit
    Please choose"
    Switch ($type){
        1 {$choice=Get-unregister}
        2 {$choice=Get-newuuid}
        3 {break}
        Default{break}
    }
    return $choice
}
Function Get-unregister{
    try{
        Invoke-Expression -Command "$Env:Programfiles\BackupClient\RegisterAgentTool\register_agent.exe -o unregister"
        $result="unregister success"
    }
    catch {
        Write-Host "An error occurred:"
        Write-Host $_
        $result="unregister Error"
    }
    return $result
}


Function Get-newuuid {
    $myArray = @()
    $myArray += (new-guid).guid
    $myArray += (new-guid).guid
    return ,$myArray
    

}




