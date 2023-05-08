SET parent=%~dp0
if exist "%parent%\token.txt" (
	    for /f "tokens=1,2 delims==" %%G in ("%parent%\token.txt") do (
            set %%G=%%H)
        @echo in cred reading %%G cloud: %cloud% token: %token%
    ) else (
	    timeout /T 1 > nul
        @echo missing info in %parent%\token.txt, please enter cloud url and token in file.
	    goto FOUND
)

"c:\Program Files\BackupClient\RegisterAgentTool\register_agent.exe" -o register -t cloud -a %cloud% --token %token%> %parent%\reg_agent.log

start "" "C:\Program Files\BackupClient\TrayMonitor\MmsMonitor.exe"
@echo registered as %hostname% under %cloud% on %date% >"%parent%\reg_done.txt"