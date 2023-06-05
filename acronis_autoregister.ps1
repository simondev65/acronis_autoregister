  
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
        $exe="$Env:Programfiles\BackupClient\RegisterAgentTool\register_agent.exe"
        $exe = $exe -replace ' ','` '
        $exe="$exe -o unregister"
        Invoke-Expression -Command $exe
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
    Write-Host "Be patient, this might take a few minutes"
    $myArray = @()
    $uuid1=(new-guid).guid
    $myArray +=  $uuid1
    $uuid2=(new-guid).guid
    $myArray +=  $uuid2
    try{
        $exe1="$Env:Programfiles\BackupClient\PyShell\bin\acropsh.exe"
        $exe2="$Env:Programfiles\BackupClient\PyShell\site-tools\change_machine_id.py"
        $exe1 = $exe1 -replace ' ','` '
        $exe2 = $exe2 -replace ' ','` '
        $exe="$exe1 $exe2 -m $uuid1 -i $uuid2"
        Invoke-Expression -Command $exe
        Write-Host "new UUID created, with number:" $myArray
    }
    catch {
        Write-Host "An uuid error occurred:"
        Write-Host $_
        Write-Host "command is : " $string
        $result="change UUID Error"
        break
    }
#wait for acronis to start
    $wait=1
    while ($wait -eq 1){
        try{
         $tcp=get-nettcpconnection -State Listen -LocalPort 43234 -ErrorAction SilentlyContinue
        }
        catch{
        Write-Host "Acronis service not started"
        Write-Host $_

        }
        if (!$tcp){
            write-host "waiting for acronis to start"
            sleep 2
        }else{
            $wait=0
            write-host "acronis started, continuing job"

        }
    
    }
#read token from file
    try{
        $read=Get-Content $path\token.txt| ConvertFrom-Stringdata
        $url=$read.values[0]
        $token=$read.values[1]
        write-host 'url: ' $url 'token:' $token
    }
    catch{
        Write-Host "An  error occurred reading token.txt, make sure it looks like url=xxx\r\n token=YYY:"
        Write-Host $_
        break
    }
    #register
    try{
        $exe="$Env:Programfiles\BackupClient\RegisterAgentTool\register_agent.exe"
        $exe = $exe -replace ' ','` '
        $exe="$exe -o register -t cloud -a $url --token $token"
        Write-Host "**registration start :" $exe
        Invoke-Expression -Command $exe
        Write-Host "**registration finished.**"
        
    }
    catch {
        Write-Host "***error*** : A registration error occurred:"
        Write-Host $_
        break
    }
    try{
        write-host "Starting acronis process..."
        $exe="$Env:Programfiles\BackupClient\TrayMonitor\MmsMonitor.exe"
        $exe = $exe -replace ' ','` '
        Start-Process -FilePath $exe
        }
    catch {
        Write-Host "An acronis starting service  error occurred:"
        Write-Host $_
        break
    }
   

    return $result
    

}
Function Check-RunAsAdministrator()
{
  #Get current user context
  $CurrentUser = New-Object Security.Principal.WindowsPrincipal $([Security.Principal.WindowsIdentity]::GetCurrent())
  
  #Check user is running the script is member of Administrator Group
  if($CurrentUser.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator))
  {
       Write-host "Script is running with Administrator privileges!"
  }
  else
    {
       #Create a new Elevated process to Start PowerShell
       $ElevatedProcess = New-Object System.Diagnostics.ProcessStartInfo "PowerShell";
 
       # Specify the current script path and name as a parameter
       $ElevatedProcess.Arguments = "& '" + $script:MyInvocation.MyCommand.Path + "'"
 
       #Set the Process to elevated
       $ElevatedProcess.Verb = "runas"
 
       #Start the new elevated process
       [System.Diagnostics.Process]::Start($ElevatedProcess)
 
       #Exit from the current, unelevated, process
       Exit
 
    }
}
 
#Check Script is running with Elevated Privileges
Check-RunAsAdministrator


$mypath = $MyInvocation.MyCommand.Path
$path= Split-Path $mypath -Parent
$h=hostname
$exe="$Env:Programfiles\BackupClient\PyShell\bin\acropsh.exe"
#$exe = $exe -replace ' ','` '
$params=@('-m', 'dmldump', '-s', 'mms', '-vs', 'Msp::Agent::Dto::Configuration');

$r=& $exe $params 

$tenant = $r[8] -replace "^.*?string',\s'(.*)'\),", '$1'
$cloud = $r[42] -replace "^.*?string',\s'(.*)'\),", '$1'
write-host "latest script on https://github.com/simondev65/acronis_autoregister"
write-host ""
if (!$tenant){
write-host "Acronis not registered yet"
  
}else{ 



write-host "****this Agent is registered to management $cloud  in the tenant $tenant" 
} 
write-host ""
write-host "Setting up Acronis Agent. Please dont close this window, it should take a few seconds"
write-host 'credential if you want to register to acronis, fill token.txt in $path'

write-host 'FYI your computername is:' $h
write-host '*** IF you want to change the hostname you can change it afterwards in windows settings***'
$choice=""
$projectType=Get-ProjectType
#write-host $projectType
Read-Host -Prompt "Press Enter to exit"
break





 
 
