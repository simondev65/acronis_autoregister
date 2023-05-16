******ACRONIS cyber protect cloud  registering tool for cloned VM*****
This Script intends to solve a common use case : being able to clone a vm (with Acronis already installed and registered) and register both the original and cloned with acronis as different machines.


How to use the script : 
1.create a token in your acronis cloud console
2.download the latest script on the target machine
3. add your tenant url and token to token.txt on the local machine
4.laucn as administrator reg_agent.cmd
5.follow the script prompt. if you are unsure do : 1 (create new ID) then y: register.


5.bis : you can also unregister, by hitting 2. this is useful if you want to create a new clean VM before ditribution. 

please open am issue on github or contribute.

known issue : if the script path contains space, the script will not run.
