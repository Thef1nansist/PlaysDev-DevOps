##Task: <br>
#13 Terraform Challenge:
Raise the following in terraform aws: the entire VPC (as in the task with aws vpc), 2 server( Bastion host + private) + Security groups + RDS + multiAZ for vps. they need to be in
separate modules, study how it interacts with each other in modules using variables.tf and output.tf .<br>

 ## Objective of the project: <br>
 The purpose of the work is to acquire practical skills in working with Terraform.  <br>
 
 ## 0. Export credo:
  ```
    export AWS_ACCESS_KEY_ID=
    export AWS_SECRET_ACCESS_KEY=
  ```
 ## 1. File main.tf
 ```
provider "aws" {
  region = "us-east-1"
}

module "vpc" {
   source = "git::https://github.com/Thef1nansist/PlaysDev-DevOps.git//modules_terraform/aws_network"
}

module "sg" {
   source = "git::https://github.com/Thef1nansist/PlaysDev-DevOps.git//modules_terraform/aws_sg"
  vpc_id = "${module.vpc.vpc_id}"
  vpc_cidr = module.vpc.vpc_cidr

}

module "rds" {
  source = "../modules/rds"
    source = "git::https://github.com/Thef1nansist/PlaysDev-DevOps.git//modules_terraform/rds"
  private_db_subnets = "${module.vpc.private_db_subnet_ids}"
  security_group_private_id = module.sg.security_group_private
}

module "ec2" {
  source = "../modules/ec2"
  source = "git::https://github.com/Thef1nansist/PlaysDev-DevOps.git//modules_terraform/ec2"
  sg_id = module.sg.security_group_public
  public_subnet_id = module.vpc.public_subnet_ids[0]
  private_subnet_id = module.vpc.private_subnet_ids[0]
}
 ```
 ## 2. Diagram
 ![image](https://user-images.githubusercontent.com/54819434/193834450-a87c8099-484b-44e9-868f-16b4fdc7d702.png)
