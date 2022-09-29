##Task: <br>
Task on Application Load Balancer and Domains

Practical part:
You need to create an nginx instance that runs on port 80 or 443 and serves your custom web page.
You need to create an instance with apache. which runs on port 80 or 443 serves your custom web page.

https://www.noip.com/ you need to create several records for the selected domain. This will look like nginx.example.com and apache.example.com
*Example.com refers to your purchased domain.

You need to create an Application Load Balancer that distributes traffic depending on which host the request comes to.
If we enter nginx.example.com into the address bar of the browser, then we get to our instance with a custom web page.
If we enter apache.example.com into the address bar of the browser, then we get to our instance with a custom web page.
If we enter google.example.com into the address bar of the browser, we get to the Google search start page <br>

 ## Objective of the project: <br>
 The purpose of the work is to acquire practical skills in working with Application Load Balancer and Domains.  <br>

 ## Create Instansec with Apache and second with Nginx
 Linux ubuntu apache run script 
 ```
#!/bin/bash
sudo apt update
sudo apt install apache2
sudo mkdir /var/www/thef1nansist
sudo chown -R $USER:$USER /var/www/thef1nansist
sudo chmod -R 755 /var/www/thef1nansist
sudo touch /var/www/thef1nansist/index.html
echo -e "<html>\n<head>\n<title>\nWelcome to Apache!\n</title>\n</head>\n<body>\n<h1>\nSuccess!  Apache!\n</h1>\n</body>\n</html>" > /var/www/thef1nansist/index.html
sudo touch /etc/apache2/sites-available/thef1nansist.conf

echo -e "<VirtualHost *:80>\nServerAdmin webmaster@localhost\nServerName your_host\nServerAlias www.your_host\nDocumentRoot /var/www/thef1nansist\nErrorLog ${APACHE_LOG_DIR}/error.log\nCustomLog ${APACHE_LOG_DIR}/access.log combined\n</VirtualHost>" > /etc/apache2/sites-available/thef1nansist.conf
sudo a2ensite thef1nansist.conf
sudo a2dissite 000-default.conf
sudo apache2ctl configtest
sudo systemctl restart apache2
 ```

 Linux ec2 nginx run script: 

 ```
#!/bin/bash 
sudo yum update -y 
sudo amazon-linux-extras install nginx1 -y 
sudo systemctl enable nginx
sudo nano /usr/share/nginx/html/index.html #change page
sudo systemctl start nginx
 ```

 ## Next steps
1.Create Load Balanser in aws;
2.Create 2 Target Groups;
3.Register target instance;
4.Create 3 CNAME DNS (noip);
5.Click "Listeners" in Load Balanser and "view/edit rules" and add rules for Load Balanser.
