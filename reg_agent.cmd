
::answer no doesnt stop script
@echo off
SETLOCAL ENABLEEXTENSIONS
SET me=%~n0
SET parent=%~dp0

::script must run as admin
::this script is used to register a new vm with a new agent, it does not rebuild a guiid, so it cannot be used on a cloned vm would was previously regiostered
@echo Setting up Acronis Agent. Please don't close this window, it should take a few seconds
@echo credential : if you want to register to acronis, create a token and enter url and token in %parent%\token.txt
::HOSTNAME
::Call %parent%\hostname.cmd not ready yet



if exist "%parent%\reg_done.txt" (
    @echo this agent is already registered

	start "" "C:\Program Files\BackupClient\TrayMonitor\MmsMonitor.exe"
   
    )
    if not exist "c:\register_agent\reg_done.txt"(
        @echo this agent is not registered yet
        
    )
    :1
         
        set /p Input=**press 1 to create a new registration ID and register again **^ press 2 to unregister this machine^ press any other key to exit:

:3

::direction following answers
if /i "%Input%" == "1" goto yes
if /i "%Input%" == "2" goto unregister
if /i "%Input%" == "n" goto commonexit

echo Not found.
goto commonexit

:yes
@echo Hostname used for registration in acronis cloud is %COMPUTERNAME% *** IF you want to change the hostname you can change it afterwards in windows settings***
goto newid



:newid
::note : may need to unregister "%ProgramFiles%\BackupClient\RegisterAgentTool\register_agent.exe" -o unregister


::@echo Step 1 of 4 - Preparing the credentials ...

::python "c:\users\student\write_creds.py"

@echo Step 2 of 4 - Configuring the ID ...

    ::this script is used to register a new vm with a new agent, it does not rebuild a guiid, so it cannot be used on a cloned vm would was previously regiostered
    @echo Setting up powershell and creating fresh ID
    powershell.exe -ExecutionPolicy Bypass %parent%\newguid.ps1 

        ::parsing guid
   
        set /p guid1=< guid1.txt 
        set /p guid2=< guid2.txt 
        @echo new id are %guid1% and %guid2% registering now
        acropsh "C:\Program Files\BackupClient\PyShell\site-tools\change_machine_id.py" -m %guid1% -i %guid2% > %parent%\change_ids.log
   
    goto startservice

    

:registernew
acropsh "C:\Program Files\BackupClient\PyShell\site-tools\change_machine_id.py" -m new -i new > %parent%\change_ids.log
  @echo registering now

 :startservice
    @echo Step 3 of 4 - Starting the services ...

:TRY
@echo in try
netstat -ano | find "43234" | find "LISTEN" > nul

if %ERRORLEVEL% equ 0 goto FOUND

timeout /T 1 > nul
goto TRY

:FOUND
set /p register=final step to add the agent to acronis cloud, credentials must be in the file, Do you want to register y/n:
if /i "%register%" == "n" goto commonexit
if /i "%register%" == "y" (
    
  call %parent%\register.cmd

)
:unregister
start "" "%ProgramFiles%\BackupClient\RegisterAgentTool\register_agent.exe" -o unregister
@echo agen unregistered 

:commonexit
PAUSE
