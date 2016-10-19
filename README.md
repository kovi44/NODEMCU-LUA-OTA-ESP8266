# ESPLoader v2

I was really inspired by Robo Durden and his nice work - ESPLoader - https://github.com/RoboDurden/ESPLoad
however it was not really suitable for my purposes so I modified it a lot and the result is my new version of ESPLoader which got some fancy functionalities.

The main goal was to update ESP8266 with nodemcu firmware easily using my server.
Basic description how it works:

1. ESP start for the 1st time, no config there so start as AP with IP 192.168.4.1
2. Connect to WIFI essid: WiFi_to_Config and open url http://192.168.4.1
3. Enter all required fields such as essid, password, host, domain, path and update interval. Submit it.
4. ESP will boot , find the config as x.txt load all variables and find that no scripts were downloaded yet, so it start the client to download it from server
5. client script will be run. it will connect to server, get the list of files to be downloaded (the very first should be the sctript you wanna run) and then download each of them
6. After succesfull download the esp will restart and start the downloaded script and also check periodically for new update. it checks the update.html file for "UPDATE" text to init the upgrade task

How to install it:
Using ESPlorer or another tool upload init.lua, config.htm, client.lua and server.lua to the esp
You should configure a webserver (raspberry pi) and create there a folder /my_esp/ and compy all files from folder html to that folder. 

It will include:
update.html - the esp scripts check if it contains "UPDATE" if yes, then a new files will be downloaded to esp. Modify it as soon as new scripts for you esp are available (don't forget to remove it after successful upgrade) 
files.html - it contains a lit of scripts to be downloaded to esp. Remeber the first script will be executed by esp.
sample.lua - just sample lua scripts
sample2.lua - just sample lua scripts 

As soon as your webserver is ready. Power on the esp8266. Configure the parameters via web gui and that's it
parametrs are stored in s.txt
and it includes
host=   -ip of your webserver
path=   -html page which contains the file list, for sample case please use files.html
ssid=   -your AP essid
pwd=	-pasword to your wifi
err=	-used for error log
boot=   -define which file must be executed 
domain=	-your webserver domain
update= -define the period of time when the esp will check for new upgrade files (defined in minutes)

Sample config (do it via web gui in AP mode)
host=192.168.0.1
path=files.html
ssid=my_wifi
pwd=my_pass123
err=
boot=
domain=mydomain.com
update=60


Hope you will enjoy it

TODO:
code some web app to handle several esps easily, and a few new features need to applied to lua code also.
For more details your emails are welcome - esp_ota(a)k0val.sk

