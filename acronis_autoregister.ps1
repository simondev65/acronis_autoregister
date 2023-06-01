 
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
         $tcp=get-nettcpconnection -State Listen -LocalPort 43234
        }
        catch{
        Write-Host "Acronis service not started"
        Write-Host $_

        }
        if (!$tcp){
            write-output "waiting for acronis to start"
            sleep 2
        }else{
            $wait=0
            write-output "acronis started, continuing job"

        }
    
    }
#read token from file
    try{
        $read=Get-Content $path\token.txt| ConvertFrom-Stringdata
        $url=$read.values[0]
        $token=$read.values[1]
        Write-Output 'url: ' $url 'token:' $token
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
        Invoke-Expression -Command $sexe
        Write-Host "**registration finished.** Starting acronis process..."
        $exe="$Env:Programfiles\BackupClient\TrayMonitor\MmsMonitor.exe"
        $exe = $exe -replace ' ','` '
        Start-Process -FilePath $exe
    }
    catch {
        Write-Host "An registration error occurred:"
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

write-output "Setting up Acronis Agent. Please dont close this window, it should take a few seconds"
write-output 'credential if you want to register to acronis, create a token and enter url and token in %parent%\token.txt'

write-output 'FYI your computername is:' $h
write-output '*** IF you want to change the hostname you can change it afterwards in windows settings***'
$choice=""
$projectType=Get-ProjectType
write-output $projectType
Read-Host -Prompt "Press Enter to exit"
break





 
