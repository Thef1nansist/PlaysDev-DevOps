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
  nano /var/www/thef1nansist/html/index.html
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
  sudo nano /etc/nginx/sites-available/thef1nansist.conf
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
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
