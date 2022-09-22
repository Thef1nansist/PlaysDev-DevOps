##Task: <br>
 You need to display the CPU load on the NGINX page intreal time, then create a daemon process that will write every 5 seconds to the NGINX log file
(when you try to kill the process, it must be restarted)
When the file reaches a size of more than 300 kb, maybe 500, (the point is in some content) the log file should be cleared
File 2 should contain a log of successful cleanups of the NGINX log file with the cleanup date and time.

Logs with 500 errors should be added separately to file 3
In file 4, you need to add logs with 400 errors

You can save any NGNIX logs you can reach

Use sed or awk to parse logs

if the file fills up too fast, increase the root log file cleanup trigger to 1 mb to 3 until you feel comfortable working with other tasks <br>

 ## Objective of the project: <br>
 The purpose of the work is to acquire practical skills in working with linux demoms, bash, nginx logs, awk/sed.<br>
 ## 0. Create cpu.sh
file /use/local/vin/cpu.sh
 ```
#!/bin/bash
while :; do
        # Get the first line with aggregate of all CPUs
        cpu_now=($(head -n1 /proc/stat))
        # Get all columns but skip the first (which is the "cpu" string)
        cpu_sum="${cpu_now[@]:1}"
        # Replace the column seperator (space) with +
        cpu_sum=$((${cpu_sum// /+}))
        # Get the delta between two reads
        cpu_delta=$((cpu_sum - cpu_last_sum))
        # Get the idle time Delta
        cpu_idle=$((cpu_now[4]- cpu_last[4]))
        # Calc time spent working
        cpu_used=$((cpu_delta - cpu_idle))
        # Calc percentage
        cpu_usage=$((100 * cpu_used / cpu_delta))

        # Keep this as last for our next read
        cpu_last=("${cpu_now[@]}")
        cpu_last_sum=$cpu_sum

        echo "CPU usage at $cpu_usage%" > /var/log/cpu.txt
        echo "CPU usage at $cpu_usage%"
        sleep 1
done
 ```

 create file cpu.txt:
 ```
sudo touch /var/log/cpu.txt
 ```
## 1. Create index.html

file: /var/www/second/index.html
```
<!DOCTYPE html>
<html>
<head>
<script>
function getCpu() {
 setInterval(() => {
        var xmlhttp;
if (window.XMLHttpRequest)
  {// код для IE7+, Firefox, Chrome, Opera, Safari
  xmlhttp=new XMLHttpRequest();
  }
else
  {// код для IE6, IE5
  xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
  }
xmlhttp.open("GET","https://thef1nansist.ddns.net/cpu.txt",false); // false - используем СИНХРОННУЮ передачу
xmlhttp.send();
document.getElementById("myDiv").innerHTML=xmlhttp.responseText;
document.querySelector('#btn').disabled = true;
    }, 100);
}
</script>
</head>
<body>

<div id="myDiv"><h2></h2></div>
<button id="btn" type="button" onclick="getCpu()">Get CPU</button>

</body>
</html>
```
## 2. Create logger.sh
```
#!/bin/bash
awk '$9 ~/^4/' /var/log/nginx/access.log > /var/log/nginx/400.log
awk '$9 ~/^5/' /var/log/nginx/access.log > /var/log/nginx/500.log
if [[ $(du /var/log/nginx/access.log | cut -f1) -gt 300 ]]; then
 > /var/log/nginx/access.log;
date +"%r %a %d %h %y (Julian Date: %j)" >> /var/log/nginx/clear.log;
 fi
```
Log files: 
```
sudo touch /var/log/nginx/500.log /var/log/nginx/400.log
```
## 3. Create linux demons
file cpu.service: 
```
[Unit]
Description=Monitor CPU utilization
After=network.target
StartLimitIntervalSec=300
StartLimitBurst=5

[Service]
Type=simple
Restart=on-failure
RestartSec=1s
User=ubuntu
ExecStart=/usr/local/bin/cpu.sh

[Install]
WantedBy=multi-user.target
```
file logger.service:
```
[Unit]
Description=Logger Nginx
After=network.target
StartLimitIntervalSec=300
StartLimitBurst=5

[Service]
Type=simple
Restart=on-failure
RestartSec=1s
User=ubuntu
ExecStart=/usr/local/bin/logger.sh

[Install]
WantedBy=multi-user.target
```
Start services:
```
sudo service cpu start
sudo service logger start
```
