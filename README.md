"Windows + WSL2" 
<br>
##Task: <br>
Create an instance in aws. Create users Dmitrij and Jon there.
Dmitry should log in each time only by ssh key to the instance. And Jon must enter his password each time he tries to log into the instance.
Dmitrij will have sudo access and john will not be able to use sudo.
Create a document from the user Dmitrij. Using permissions to do so - so that the user Jon could not read the contents of the document.
+ Create a new user so that he has the sh interpreter by default. <br>

 ## Objective of the project: <br>
 The purpose of the work is to acquire practical skills in working with AWS EC2, Linux, Ssh connection, WSL2.  <br>
 
 ## 0. Create AWS EC2 Instance:
  1. You need to go to the AWS and in the search from above find the service EC2.
  2. Go to the instances tab and press the button "Launch Instances", there you set the necessary parameters,
  generate a ssh key and then press the button "Launch Instance", after a couple of seconds, instance will start.
  
  ## 1. Connection to EC2 instance via ssh
  ```
  sudo ssh -i YourKey.pem ec2-user@YourHost
  ```
  -i - Selects a file from which the identity (private key) for public key authentication is read.
  
  ## 2. Create user Dmitriy
  ```
  sudo adduser -m Dmitriy
  ```
  -m - Create with home dir.
  
  ## 3. Grant rights to Dmitry wheel and set a password
  
  ```
  [ec2-user@ip-172-31-85-97 ~]$ sudo usermod -aG wheel Dmitriy
  [ec2-user@ip-172-31-85-97 ~]$ groups Dmitriy
  Dmitriy : Dmitriy wheel
  [ec2-user@ip-172-31-85-97 ~]$ sudo passwd Dmitriy
  Changing password for user Dmitriy.
  ```
  Let's check Dmitry's rights
  ```
  su Dmitriy
  sudo cat /etc/shadow
  ```
  If you can see it, great!
  
  ## 4. Create a folder .ssh with file authorized_keys
  
  ```
  [ec2-user@ip-172-31-85-97 ~]$ sudo su - Dmitriy
  [Dmitriy@ip-172-31-85-97 ~]$ mkdir .ssh
  [Dmitriy@ip-172-31-85-97 ~]$ ls -la
  [Dmitriy@ip-172-31-85-97 ~]$ touch .ssh/authorized_keys
  ```
  Setting permissions for folder and file:
  ```
  [Dmitriy@ip-172-31-85-97 ~]$ chmod 700 .ssh
  [Dmitriy@ip-172-31-85-97 ~]$ chmod 600 .ssh/authorized_keys
  ```
  Open the SSH daemon configuration file:
  ```
  [ec2-user@ip-172-31-85-97 ~]$ cd /etc/ssh/
  [ec2-user@ip-172-31-85-97 ssh]$ sudo su - Dmitriy
  [ec2-user@ip-172-31-85-97 ssh]$ sudoedit sshd_config
  ```
 Find the PasswordAuthentication directive in the file and make it yes:
 ```
 PasswordAuthentication yes
 ```
  On CentOS/Fedora machines, this daemon is named sshd:
  ```
  sudo systemctl sshd restart
  ```
  ## 5. Create access keys for Dmitriy on the local machine
  
  ```
  ssh-keygen -I Dmitriy
  ```
  -I - certificate_identity
  Fill in the details and click Enter
  If you want to encrypt your key, enter the password in the passphrase field;
  To view your public key, enter:
  ```
  cat ~/.ssh/public_key.pub
  ```
  
  ## 6. Copy the public key to ec2@-instance
  
  ```
  yourPC:/mnt/c/Users/you/folder$ sudo ssh -i secondPlaysDev.pem ec2-user@YourHost
  [ec2-user@ip-172-31-85-97 ~]$ sudo cd /home/Dmitriy/
  [ec2-user@ip-172-31-85-97 ~]$ su Dmitriy
  [Dmitriy@ip-172-31-85-97 ec2-user]$ cd
  [Dmitriy@ip-172-31-85-97 ~]$ cd .ssh/
  [Dmitriy@ip-172-31-85-97 .ssh]$ cat >> authorized_keys
  
  ```
  Copy and then public key into authorized_keys file.
  
  ## 7. We are trying to connect via ssh through Dmitriy
  
  ```
  yourPC:/mnt/c/Users/you/folder$ cd
  yourPC:~$ ssh -i .ssh/public_key Dmitriy@YourHost
  ```
  
  ## 8. Create User Jon
  
  ```
  [Dmitriy@ip-172-31-85-97 ~]$ sudo useradd -m Jon
  [sudo] password for Dmitriy:
  [Dmitriy@ip-172-31-85-97 ~]$ sudo passwd Jon
  ```
  
  ## 9. Create Dmitriy file and permissions
  Connecting with Jon:
  
  ```
  yourPC:~$ ssh Jon@YourHost
  ```
  
  Checking for sudo with Jon:
  ```
  [Jon@ip-172-31-85-97 ~]$ sudo cat /etc/shadow
  Jon is not in the sudoers file.  This incident will be reported.
  ```
  Good.
  
  Сreate a file under Dmitriy in John's directory:
  ```
  [Jon@ip-172-31-85-97 ~]$ su Dmitriy
  [Dmitriy@ip-172-31-85-97 Jon]$ pwd
  /home/Jon
  [Dmitriy@ip-172-31-85-97 Jon]$ sudo touch file
  [Dmitriy@ip-172-31-85-97 Jon]$ sudo chown Dmitriy file
  [Dmitriy@ip-172-31-85-97 Jon]$ ls -la
  ```
  Changing file permissions:
  ```
  [Dmitriy@ip-172-31-85-97 Jon]$ sudo chmod 600 file
  
  ls -la
  -rw------- 1 Dmitriy root   0 Sep 14 09:51 file
  ```
  ## 10. Create User with sh interpreter by default
  ```
  [Dmitriy@ip-172-31-85-97 Jon]$ sudo adduser -m -s /bin/sh TestUser
  [Dmitriy@ip-172-31-85-97 Jon]$ sudo passwd TestUser
  [Dmitriy@ip-172-31-85-97 Jon]$ su TestUser
  sh-4.2$ echo $0
  sh
  ```
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
