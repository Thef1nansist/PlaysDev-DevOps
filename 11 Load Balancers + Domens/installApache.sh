#!/bin/bash
sudo apt update
sudo apt install apache2
sudo mkdir /var/www/thef1nansist
sudo chown -R $USER:$USER /var/www/thef1nansist
sudo chmod -R 755 /var/www/thef1nansist
sudo touch /var/www/thef1nansist/index.html
echo -e "<html>\n<head>\n<title>\nWelcome to Your_domain!\n</title>\n</head>\n<body>\n<h1>\nSuccess!  The your_domain virtual host is working!\n</h1>\n</body>\n</html>" > /var/www/thef1nansist/index.html
sudo touch /etc/apache2/sites-available/thef1nansist.conf

echo -e "<VirtualHost *:80>\nServerAdmin webmaster@localhost\nServerName thef1nansist.ddns.net\nServerAlias www.thef1nansist\nDocumentRoot /var/www/thef1nansist\nErrorLog ${APACHE_LOG_DIR}/error.log\nCustomLog ${APACHE_LOG_DIR}/access.log combined\n</VirtualHost>" > /etc/apache2/sites-available/thef1nansist.conf
sudo a2ensite thef1nansist.conf
sudo a2dissite 000-default.conf
sudo apache2ctl configtest
sudo systemctl restart apache2