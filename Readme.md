******ACRONIS cyber protect cloud  registering tool *****
This Script intends to solve a few common use case : <br>
1/show you where the machine is currently registered<br>
2/unregister and register to any tenant with a token<br>
3/enabling you to clone machine with agents without any issues, and then register to any tenant. It Avoids duplication of UUID, by creating a new UUID.<br>
4/if you have trouble registering your agent to acronis cloud, this script will tell you if the agent is already registered, and by choosing option 2, you will be able to register it with a new unique ID. This will solve any duplicated ID issue if the machine was already registered to another tenant.
**How do i know i'm running into this duplicated ID issue ?: the logs in c:\programdata\acronis\installationlogs\DATE\boostrapper.log : you will see a log "Agent wit ID XX is already registered in a different tenant"**
![registered](https://github.com/simondev65/acronis_autoregister/assets/9587627/e2476435-e720-4946-bd32-e4fe0f7347f1)


How to use the script : <br>
<br>1.create a token in your acronis cloud console
<br>2.download the latest script on the target machine
<br>3. add your tenant url and token to token.txt on the local machine
<br>4.launch  acronis_autoregister.ps1 (if script)
    4.1 if you get error : “Running Scripts is Disabled on this System”, run powershell as admin and run Set-ExecutionPolicy -ExecutionPolicy bypass -Scope CurrentUser
<br>
<br>5.follow the script prompt. <br>the first line will tell you were your agent is registered currently. <br>if you are unsure do : <br>1 unregister to clear any existing registration  then relaunch the script and do <br>2: register.<br><br>
important Note : option 2 will register with the current UUID of the machine<br>
OPtion 3 will create a new Unique Identifier and register under this new identifier, removing any possibility of duplicate entry in Acronis, and therefore enabling you to register a cloned machine without issues

<br>
please open am issue on github or contribute.
