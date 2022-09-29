##Task: <br>
Write a script in python to create a machine. then use a python to get all the information about the car (ip, os, metrics, size + type), change the key from it and then kill everything with the python code.
Make another script (bash) to install aws cli which will understand which operating system. after installation, deal with the credits and make a profile. By default, the OS reads ONLY bash scripts. Those. no python and other programming languages. It is worth using native OS package managers. The script should work under Redhat, Ubuntu, MacOS, Windows (+ others if desired) <br>

 ## Objective of the project: <br>
 The purpose of the work is to acquire practical skills in working with AWS EC2, IAM, Python(boto3), Bash.  <br>

 ## Create EC2 Instanse from Python(boto3) and get info about Instance
    I use ubuntu 22.04;
    The first you need install pip3, boto3:
    ```
    sudo apt install python3-pip
    pip3 --version
    pip3 isntall boto3
    ```
    File script.py:
 ```
import boto3 
ec2 = boto3.resource( 'ec2' )
client_session = boto3.client('ec2')

instances = ec2.create_instances( 
     ImageId= 'ami-026b57f3c383c2eec' , 
     MinCount=1, 
     MaxCount=1, 
     InstanceType= 't2.micro' , 
     KeyName= 'ec2-keypair'
  )

asg_response = client_session.describe_instances(
            InstanceIds=[
        str(instances[0])[17:36],
                        ],
        )

pythonins = asg_response['Reservations'][0]['Instances'][0]

print("PrivateIpAddress: " + pythonins['PrivateIpAddress'])
# print("PublicIpAddress: " + pythonins['PublicIpAddress'])
print("OS: " + pythonins['PlatformDetails'])
print("Instance type: " + pythonins['InstanceType'])


volume_iterator = ec2.volumes.all()
print(volume_iterator)
for v in volume_iterator:
        print("{0} {1} {2}".format(v.id, v.state, v.size) + " GB")
print(v)
 ```

 ## Change ssh key from remoute instance
```
pip3 isntall paramiko;
```
File changeRemouteSSHKey.py:
```
from curses import echo
import paramiko

ssh = paramiko.SSHClient()
ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
ssh.connect(hostname='ip_host', username='ec2-user', key_filename='ssh_key.pem')

stdin, stdout, stderr = ssh.exec_command('echo "ssh-rsa sadasd;mmds" > /home/ec2-user/.ssh/authorized_keys')
stdin.close()

stdin, stdout, stderr = ssh.exec_command('lsb_release -a')

for line in stdout.read().splitlines():
    print(line)

ssh.close()
```

## Kill instanse
File removeInstance.py:
```
import boto3
import sys

client = boto3.client('ec2')
if (sys.argv[1]):
    response = client.terminate_instances(
    InstanceIds=[
        sys.argv[1],
    ],
)

print(response)
```
Start command: 

```
python3 removeInstance.py id_Image
```

## Create bash script
File isntallAWSCli.sh
```

#!/bin/bash
source .env
case "$OSTYPE" in
  darwin*)
        curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "AWSCLIV2.pkg"
        sudo installer -pkg AWSCLIV2.pkg -target /
        sudo mkdir ~/.aws
        sudo aws configure set profile.default.region $region
        sudo aws configure set profile.default.aws_access_key_id $access_public
        sudo aws configure set profile.default.aws_secret_access_key $access_secret
        ;;
  linux*)
     echo "LINUX"
        type=$(awk '/^NAME/' /etc/*-release);
     if [ -f /etc/redhat-release ] ; then
            sudo dnf install awscli
            sudo mkdir ~/.aws
            sudo aws configure set profile.default.region $region
            sudo aws configure set profile.default.aws_access_key_id $access_public
            sudo aws configure set profile.default.aws_secret_access_key $access_secret
        elif [ -f /etc/SuSE-release ] ; then
            sudo zypper in aws-cli
            sudo mkdir ~/.aws
            aws configure set profile.default.region $region
            aws configure set profile.default.aws_access_key_id  $access_public
            aws configure set profile.default.aws_secret_access_key $access_secret
        elif [ $type  == 'NAME="Debian"' ] ; then
            sudo apt install awscli
            sudo mkdir ~/.aws
            sudo aws configure set profile.default.region $region
            sudo aws configure set profile.default.aws_access_key_id $access_public
            sudo aws configure set profile.default.aws_secret_access_key $access_secret
        elif [ $type == 'NAME="Ubuntu"' ] ; then
            sudo apt install awscli
            sudo mkdir /root/home/ubuntu/.aws
            sudo aws configure set profile.default.region $region
            sudo aws configure set profile.default.aws_access_key_id $access_public
            sudo aws configure set profile.default.aws_secret_access_key $access_secret
        fi
    ;;
  msys*)
        echo "WINDOWS"
        powerShell "msiexec.exe /i https://awscli.amazonaws.com/AWSCLIV2.msi "

  ;;
  *)        echo "unknown: $OSTYPE" ;;
esac
```
File .env:
```
access_public=AKIA235VEN7Z2NCRCM25
access_secret=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
region=us-east-1
```
