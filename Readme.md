******ACRONIS cyber protect cloud  registering tool for cloned VM*****
This Script intends to solve a common use case : 
a/to which Acronis Cyber protect cloud tenant is my VM registered ? 
b/being able to clone a vm (with Acronis already installed and registered) and register both the original and cloned with acronis as different machines.


How to use the script : 
1.create a token in your acronis cloud console
2.download the latest script on the target machine
3. add your tenant url and token to token.txt on the local machine
4.launch  acronis_autoregister.ps1 (if script)
    4.1 if you get error : “Running Scripts is Disabled on this System”, run powershell as admin and run Set-ExecutionPolicy -ExecutionPolicy bypass -Scope CurrentUser

5.follow the script prompt. the first line will tell you were your agent is registered currently. if you are unsure do : 1 unregister to clear any existing registration  then relaunch the script and do 2: register.


please open am issue on github or contribute.

known issue : the Acronis launch at the end of the script doesn't work yet. you need to relaunch acronis manually.
