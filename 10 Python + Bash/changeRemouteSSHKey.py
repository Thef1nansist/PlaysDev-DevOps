from curses import echo
import boto3
import botocore
import paramiko

ssh = paramiko.SSHClient()
ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
ssh.connect(hostname='3.93.234.7', username='ec2-user', key_filename='/mnt/c/Users/vlads/work/playsDev.pem')

stdin, stdout, stderr = ssh.exec_command('echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCmTAWyYKhpI2ubqi5GgyjatnfdXwx3PWZNMwAJm1ij5NqCG+z4wL6sQjY2Z65q2mT99WBMSQO8rBvyDt9Hvj5yezuGfQEhZWEAvUiTHg2EWbn6LR+IV501vkjuJi7ZcfXlJQd8cOeg/MnSNQ0/FjwasmUGY9RJsFDTW3ygcpxhfLzFceDwtAOH3z/shrozroVcZ+mFh8ygILFbvwz6t05OYqLTK4IJJ2dT1HLcA5d5xWCPC5NPuQYI+lmZYcJyonfPGccC6zDHof8bYw2ADwzAKKgO2u2WvnKv6n0T+YOtDMxte1LnOlXZjKS/nL1jds3sI78w/kOxbhJhZKj96g1+pcetS4VEDX3/dybDXtqe3AgWf2v8l/JCGTS55wY5AIjyHL6KDYsHz1pmoZ0mBVrTUwqyg+6pBN5rDYAHzwfMMdQFuFpDpYUBqbqydjAn+GEJz8SHUef6VjZxrYh4vcc5yDdQhvUyMNtcPRAcfPFvKcJIwD+uIKoqNHodeAumyDU= vlad@DESKTOP-VHNU9VV" > /home/ec2-user/.ssh/authorized_keys')
stdin.close()

stdin, stdout, stderr = ssh.exec_command('lsb_release -a')

for line in stdout.read().splitlines():
    print(line)

ssh.close()