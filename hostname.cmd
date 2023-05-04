@echo off
SETLOCAL ENABLEEXTENSIONS
SET me=%~n0
SET parent=%~dp0
@echo current name is  %COMPUTERNAME% it's easier if the name is unique in your tenant.
set /p Input=Do you want to change the hostname ? Enter y or n:
if /i "%Input%" == "y" goto yes
if /i "%Input%" == "n" goto commonexit
:yes
set /p host=enter NEW computername:
WMIC ComputerSystem where Name="%COMPUTERNAME%" call Rename Name="%host%"
@echo new name set to %host%
@echo computername is %COMPUTERNAME%
:commonexit
EXIT