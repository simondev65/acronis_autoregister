
@echo off
::script must run as admin
::this script is used to register a new vm with a new agent, it does not rebuild a guiid, so it cannot be used on a cloned vm would was previously regiostered
@echo Setting up Acronis Agent. Please don't close this window, it should take a few seconds

if exist "c:\register_agent\reg_done.txt" (
	start "" "C:\Program Files\BackupClient\TrayMonitor\MmsMonitor.exe"
	EXIT
)
@echo Hostname used for registration in acronis cloud is %COMPUTERNAME%


::@echo Step 1 of 4 - Preparing the credentials ...

::python "c:\users\student\write_creds.py"

@echo Step 2 of 4 - Configuring the ID ...

acropsh "C:\Program Files\BackupClient\PyShell\site-tools\change_machine_id.py" -m new -i new > change_ids.log
@echo change id done
@echo Step 3 of 4 - Starting the services ...

:TRY
@echo in try
netstat -ano | find "43234" | find "LISTEN" > nul

if %ERRORLEVEL% equ 0 goto FOUND

timeout /T 1 > nul
goto TRY

:FOUND
@echo in found
if exist "c:\register_agent\credentials.txt" (
	for /f "tokens=1,2 delims==" %%G in (c:\register_agent\credentials.txt) do (
        set %%G=%%H
    @echo in cred %%G %username% %password%)
) else (
	timeout /T 1 > nul
	goto FOUND
)

@echo Step 4 of 4 - Registering the Agent ...

"c:\Program Files\BackupClient\RegisterAgentTool\register_agent.exe" -o register -t cloud -a https://cloud.acronis.com -u %username% -p %password% > reg_agent.log

start "" "C:\Program Files\BackupClient\TrayMonitor\MmsMonitor.exe"
@echo registered as %hostname% under login %username% on %date% >c:\register_agent\reg_done.txt



