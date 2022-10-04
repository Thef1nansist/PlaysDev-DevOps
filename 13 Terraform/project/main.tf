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