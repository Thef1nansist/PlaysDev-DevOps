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