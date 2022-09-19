"WSL2-Ubuntu22.04-Nginx-Apache-PHP-SSL" 
<br>
##Task: <br>
You need to implement an NGINX-based reverse proxy that will proxy requests:
•something to the local machine
•something to another port
•something to another server.
The concept is this:
I am knocking on the server (NGINX) on port 80 and should see a description, something like:
•If you want to get to the page with content 1, then click here (and we get to another page that is processed by the same NGINX just on a different port or dns name).
•If you want to download a file with music, click here and you can download mp3 from the link. (IP/music)
•If you need a server running on Apache+PHP, click here and the link gives information about the PHP server (IP/info.php)
•If you want to get a response from another server, click here and here you already see a site that is not given by a proxy, but by another server (IP/secondserver)<br>

 ## Objective of the project: <br>
 The purpose of the work is to acquire practical skills in working with WSL2, Ubuntu, Nginx, Apache+PHP, SSL.  <br>
 
 ## 0. Create AWS EC2 Instance:
  1. You need to go to the AWS and in the search from above find the service EC2.
  2. Go to the instances tab and press the button "Launch Instances", there you set the necessary parameters, choose OS Ubuntu,
  generate a ssh key and then press the button "Launch Instance", after a couple of seconds, instance will start.
  
  ## 1. Connection to EC2 instance via ssh
  ```
  sudo ssh -i YourKey.pem ubuntu@YourHost
  ```
  -i - Selects a file from which the identity (private key) for public key authentication is read.
  
  ## 2. Update OS
  Update your Ubuntu to make sure all existing packages are up to date:
  ```
  sudo apt update && sudo apt upgrade
  ```
  
  ## 3. Install Nginx from the Ubuntu repository.
  To install Nginx, run the following command:
  ```
  sudo apt install nginx
  ```
  Type "Y" then press "ENTER KEY" to proceed with the installation.

  Then check the assembly version and the success of the installation:
  ```
  sudo nginx -v
  ```
  ## 4. Customize UFW Configuration
  [ufw](https://www.digitalocean.com/community/tutorials/how-to-set-up-a-firewall-with-ufw-on-ubuntu-18-04-ru)
  If UFW is not installed, reinstall the firewall with the following command:
  ```
  sudo apt install ufw -y
  ```
  Then enable UFW with the following command:
  ```
  sudo ufw enable
  sudo ufw app list
  ```
  You can then enable Nginx to HTTP (port 80), HTTPS (port 443), ssh (port 22), port: 81, 8080 or Full, including all options:
  ```
  sudo ufw allow 'Nginx HTTP'
  sudo ufw allow 'Nginx HTTPS'
  sudo ufw allow 'Nginx FULL'
  sudo ufw allow ssh
  sudo ufw allow 8080
  sudo ufw allow 81
  ```
  
  Confirm that the firewall rules are active with the following command:
  ```
  sudo ufw status
  ```
  After configuring UFW, make sure you can see the Nginx landing page in your internet browser.
  ```
  http://your_server_ip
  ```
  or 
  ```
  sudo service nginx restart
  http://your_server_ip
  ```
  
  ## 5. Set up an Nginx server
  Find Server IP: 
  ```
  curl -4 icanhazip.com
  ```
  
  First, create a directory, for thef1nansist.ddns.net , as follows, using the "-p" flag to create all necessary parent directories:
  ```
  sudo mkdir -p /var/www/thef1nansist
  ```
  Second, you will need to assign an owner to the directory:
  ```
  sudo chown -R $USER:$USER /var/www/thef1nansist
  ```
  Thirdly, assign permissions to the directory:
  ```
  sudo chmod -R 755 /var/www/thef1nansist
  ```
  
  ## 6. Set up a main HTML page
  
  Create page:
  ```
  nano /var/www/thef1nansist/index.html
  ```
  Inside the nano editor and the new file you created. Enter the following:
  ```
<!doctype html>
<html>
<head>
    <meta charset="utf-8">
    <title>Hello!</title>
</head>
<body>
   <p>Page content 1, click:</p>
   <a href="second/index.html">1</a>
   <p>Download music, click:</p>
   <a href="static/file2.mp3">2</a>
   <p>Server Apache + PHP, click:</p>
   <a href="info/info.php">3</a>
   <p>Response with another server</p>
   <a href="https://www.facebook.com/">4</a>
</body>
</html>
  ```
  Save the file CTRL+S, then exit CTRL+X .
  
  ## 7. Create an Nginx server block
  
  Create a new server block as follows:
  ```
  sudo nano /etc/nginx/sites-available/thef1nansist
  ```
  
  Open file:
  ```
  sudo nano /etc/nginx/nginx.conf
  ```
  And uncomment the following line:
  ```
  server_names_hash_bucket_size 64;
  ```
  Then test nginx 
  ```
  sudo nginx -t
  nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
  nginx: configuration file /etc/nginx/nginx.conf test is successful
  ```
  then: 
  ```
  sudo service nginx restart 
  ```
  Now you can test your site: http://thef1nansist.ddns.net/
  
  ## 8. Nginx + Let's Encrypt SSL certificate
  First install the certbot package as follows:
  ```
  sudo apt install python3-certbot-nginx -y
  ```
  Once installed, run the following command to start generating the certificate:
  ```
  sudo certbot --nginx --agree-tos --redirect --hsts --staple-ocsp --email you@example.com -d thef1nansist.ddns.net
  ```
  Your URL will now be HTTPS://thef1nansist.ddns.net instead of HTTP://thef1nansist.ddns.net.
  
  ## 9. Installing Apache and configuring the firewall
  Install Apache using the Ubuntu apt package manager:
  ```
  sudo apt install apache2
  ```
  Firewall configuration to allow web traffic:
  ```
  sudo ufw app info "Apache Full"
  ```
  You can check the installation result by typing:
  ```
  http://IP:8080
  ```
  Next, in the /var/www/html folder, you need to create a file that will open the PHP configuration page:
  ```
  $ cd /var/www/html
  $ echo "<?php phpinfo(); ?>" | sudo tee /var/www/html/info.php
  ```
  ## 10. Installing PHP
  ```
  sudo apt install php libapache2-mod-php
  sudo nano /etc/apache2/mods-enabled/dir.conf
  ```
  place index.php in first place
  Now you can go: http://IP:8080/info.php
  
  ## 11. Create folders and files for task
  ```
  sudo mkdir /var/www/html/static_files/ #create folder with static files
  sudo touch file2.mp3 
  sudo mkdir /var/www/second #create folder with second server(another port(81))
  cd /var/www/second
  sudo nano index.html #In index.html add <p>second server</p>
  ```
  ## 11. Virtual host setup Nginx
  File: /etc/nginx/sites-enabled/thef1nansist
  ```
  server {

 root /var/www/thef1nansist;

  index index.html index.htm index.nginx-debian.html;
  server_name thef1nansist.ddns.net www.thef1nansist.ddns.net;

 location / {
  try_files $uri $uri/ =404;
 }

 location  /static/ {
  alias /var/www/html/static_files/;
  add_header Content-disposition "attachment";
 }

 location /info/info.php {
 proxy_pass http://IP:8080/info.php;
 proxy_set_header Host $host;
 proxy_set_header X-Real-IP $remote_addr;
 proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
 proxy_set_header X-Forwarded-Proto $scheme;
 }

 location /second/index.html {
 proxy_pass http://IP:81/index.html;
 proxy_set_header Host $host;
 proxy_set_header X-Real-IP $remote_addr;
 proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
 proxy_set_header X-Forwarded-Proto $scheme;
 }

    listen [::]:443 ssl ipv6only=on; # managed by Certbot
    listen 443 ssl; # managed by Certbot
    ssl_certificate /etc/letsencrypt/live/thef1nansist.ddns.net/fullchain.pem; # managed by Certbot
    ssl_certificate_key /etc/letsencrypt/live/thef1nansist.ddns.net/privkey.pem; # managed by Certbot
    include /etc/letsencrypt/options-ssl-nginx.conf; # managed by Certbot
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem; # managed by Certbot


    add_header Strict-Transport-Security "max-age=31536000" always; # managed by Certbot


    ssl_trusted_certificate /etc/letsencrypt/live/thef1nansist.ddns.net/chain.pem; # managed by Certbot
    ssl_stapling on; # managed by Certbot
    ssl_stapling_verify on; # managed by Certbot

}
server {
    if ($host = thef1nansisttest.ddns.net) {
        return 301 https://$host$request_uri;
    } # managed by Certbot


 listen 80;
 listen [::]:80;

 root /var/www/thef1nansist;

  index index.html index.htm index.nginx-debian.html;
  server_name thef1nansist.ddns.net www.thef1nansist.ddns.net;

 location / {
  try_files $uri $uri/ =404;
 }

}
server {
listen 81;
listen [::]:81;

  root /var/www/second;
  index index.html index.htm;
  server_name thef1nansist.ddns.net www.thef1nansist.ddns.net;

location / {
 try_files $uri $uri/ =404;
}
}
  ```
  
 #Task5:
 Based on the previous task, you need to create two more servers, in nginx and make the transition to / redblue and what would:
1.after the first transition to this path there will be a red page
2. after the second transition to this address, you need to get a blue page.
(To do this, use balancing and proxying.)

• you need to create a transition to /image1 where there will be jpg and /image2 where there will be png.
•+ Make a regular expression for pictures. If the format is jpg, then the image will be flipped using nginx.
•when displaying logs, show where the client's request was proxied. </br>

## 12. Add Upstream

Open file and add upstream:
```
sudo nano /etc/nginx/conf.d/upstreams.conf
#In upstreams.conf: 
upstream bluered_backend {
        server IP:82;
        server IP:83;
}
```
## 13. Create 2 servers

```
sudo nano /etc/nginx/sites-enabled/thef1nansist
```
Add the following to the file:

```
server {
---
location ~ \.(jpg|gif)$ {
image_filter rotate 180;
root /var/www/html/static_files/;
}
location ~ \.(png)$ {
root /var/www/html/static_files/;
}
location /redblue {
 proxy_pass http://bluered_backend;
}
---
}
---
server {
listen 82;
listen [::]:82;

  root /var/www/second/red;
  index index.html index.htm;
  server_name thef1nansist.ddns.net www.thef1nansist.ddns.net;

  location / {
        try_files $uri $uri/ /index.html;
  }
}

server {
listen 83;
listen [::]:83;

 root /var/www/second/blue;
 index index.html index.htm;
 server_name thef1nansist.ddns.net www.thef1nansist.ddns.net;

  location / {
        try_files $uri $uri/ /index.html;
  }
}

```

Now Open port 82 and 83 and restart Nginx: 
```
sudo ufw allow 82 83
sudo service nginx restart
```
Add images:
```
cd /var/www/html/static_files
sudo wget https://tinypng.com/images/social/website.jpg
sudo mv website.jpg image1.jpg
sudo wget https://www.adobe.com/express/feature/image/media_16ad2258cac6171d66942b13b8cd4839f0b6be6f3.png?width=750&format=png&optimize=medium
sudo mv media... image2.png
```
Now you can check:
1.https://thef1nansisttest.ddns.net/redblue
2.https://thef1nansisttest.ddns.net/image1.jpg
3.https://thef1nansisttest.ddns.net/image2.png

## 14. Add logging
Create 2 files:
```
sudo touch /var/log/nginx/thef1nansist.ddns.net-access.log
error_log /var/log/nginx/thef1nansist.ddns.net-error.log;
```
## 15. File thef1nansist
```
server {
 root /var/www/thef1nansist;

  index index.html index.htm index.nginx-debian.html;
  server_name thef1nansist.ddns.net www.thef1nansist.ddns.net;

 location / {
  try_files $uri $uri/ =404;
 }

 location /static/ {
  alias /var/www/html/static_files/;
  add_header Content-disposition "attachment";
 }

 location ~ \.(jpg|gif)$ {
  image_filter rotate 180;
  root /var/www/html/static_files/;
}

 location ~ \.(png)$ {
  root /var/www/html/static_files/;
}

 location /info/info.php {
  proxy_pass http://54.198.251.77:8080/info.php;
  proxy_set_header Host $host;
  proxy_set_header X-Real-IP $remote_addr;
  proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
  proxy_set_header X-Forwarded-Proto $scheme;
}

 location /second/index.html {
  proxy_pass http://54.198.251.77:81/index.html;
  proxy_set_header Host $host;
  proxy_set_header X-Real-IP $remote_addr;
  proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
  proxy_set_header X-Forwarded-Proto $scheme;
 }

 location /redblue {
  access_log /var/log/nginx/thef1nansist.ddns.net-access.log;
  error_log /var/log/nginx/thef1nansist.ddns.net-error.log;
  
  proxy_pass http://bluered_backend;
}

    listen [::]:443 ssl ipv6only=on; # managed by Certbot
    listen 443 ssl; # managed by Certbot
    ssl_certificate /etc/letsencrypt/live/thef1nansist.ddns.net/fullchain.pem; # managed by Certbot
    ssl_certificate_key /etc/letsencrypt/live/thef1nansist.ddns.net/privkey.pem; # managed by Certbot
    include /etc/letsencrypt/options-ssl-nginx.conf; # managed by Certbot
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem; # managed by Certbot
    
    add_header Strict-Transport-Security "max-age=31536000" always; # managed by Certbot
    
    ssl_trusted_certificate /etc/letsencrypt/live/thef1nansist.ddns.net/chain.pem; # managed by Certbot
    ssl_stapling on; # managed by Certbot
    ssl_stapling_verify on; # managed by Certbot

}

server {
    if ($host = thef1nansist.ddns.net) {
        return 301 https://$host$request_uri;
    } # managed by Certbot

 listen 80;
 listen [::]:80;

 root /var/www/thef1nansist;

  index index.html index.htm index.nginx-debian.html;
  server_name thef1nansist.ddns.net www.thef1nansist.ddns.net;

 location / {
  return 301 https://thef1nansist.ddns.net;
 }

}

server {
listen 81;
listen [::]:81;

  root /var/www/second;
  index index.html index.htm;
  server_name thef1nansist.ddns.net www.thef1nansist.ddns.net;

  access_log /var/log/nginx/thef1nansist.ddns.net-access.log;
  error_log /var/log/nginx/thef1nansist.ddns.net-error.log;

location / {
 try_files $uri $uri/ =404;
}
}

server {
listen 82;
listen [::]:82;

  root /var/www/second/red;
  index index.html index.htm;
  server_name thef1nansist.ddns.net www.thef1nansist.ddns.net;

  access_log /var/log/nginx/thef1nansist.ddns.net-access.log;
  error_log /var/log/nginx/thef1nansist.ddns.net-error.log;

  location / {
        try_files $uri $uri/ /index.html;
  }

}
server {
listen 83;
listen [::]:83;

 root /var/www/second/blue;
 index index.html index.htm;
 server_name thef1nansist.ddns.net www.thef1nansist.ddns.net;

  access_log /var/log/nginx/thef1nansist.ddns.net-access.log;
  error_log /var/log/nginx/thef1nansist.ddns.net-error.log;

  location / {
        try_files $uri $uri/ /index.html;
  }
}
```
#File thef1nansist/index.html
```
<!doctype html>
<html>
<head>
    <meta charset="utf-8">
    <title>Hello!</title>
</head>
<body>
    <p>Page content 1, click:</p>
   <a href="second/index.html">1</a>
   <p>Download music, click:</p>
   <a href="static/file2.mp3">2</a>
   <p>Server Apache + PHP, click:</p>
   <a href="info/info.php">3</a>
   <p>Response with another server</p>
   <a href="https://www.facebook.com/">4</a></br>
   Task 5:
   <p>Redblue</p>
   <a href="/redblue">1</a>
   <p>Jpg</p>
   <a href="/image1.jpg">2</a>
   <p>Png</p>
   <a href="/image2.png">3</a>
</body>
</html>
```


  
  
  
  
  
  
  
  
  
  
  
  
  
  
