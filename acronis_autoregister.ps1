
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
    $uuid1=(new-guid).guid
    $myArray +=  $uuid1
    $uuid2=(new-guid).guid
    $myArray +=  $uuid2
    try{
        $string="acropsh C:\Program Files\BackupClient\PyShell\site-tools\change_machine_id.py -m $uuid1 -i $uuid2"
        Invoke-Expression -Command $string
    }
    catch {
        Write-Host "An uuid error occurred:"
        Write-Host $_
        
        Write-Host "command is : " $string
        $result="change UUID Error"
    }
    return ,$myArray
    

}


$h=hostname

write-output "Setting up Acronis Agent. Please dont close this window, it should take a few seconds"

write-output "***credential***  if you want to register to acronis, create a token and enter url and token in %parent%\token.txt"

write-output 'FYI your computername is:' $h
write-output '*** IF you want to change the hostname you can change it afterwards in windows settings***'
$choice=""
$projectType=Get-ProjectType
write-output $projectType
break






