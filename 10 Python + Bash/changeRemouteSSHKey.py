from curses import echo
import boto3
import botocore
import paramiko

ssh = paramiko.SSHClient()
ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
ssh.connect(hostname='ip_host', username='ec2-user', key_filename='key.pem')

stdin, stdout, stderr = ssh.exec_command('echo "ssh-rsa nOььььь" > /home/ec2-user/.ssh/authorized_keys')
stdin.close()

stdin, stdout, stderr = ssh.exec_command('lsb_release -a')

for line in stdout.read().splitlines():
    print(line)

ssh.close()
