resource "aws_instance" "Bastion" {
  ami           = var.ami
  instance_type = var.instance_type
  key_name = var.key_name
  vpc_security_group_ids = [var.sg_id]
  subnet_id              =  var.public_subnet_id

  tags = {
    Instance = "Bastion"
    Terraform   = "true"
    Environment = "dev"
  }
}

resource "aws_instance" "privateInstance" {
  ami           = var.ami
  instance_type = var.instance_type
  key_name = var.key_name
  vpc_security_group_ids = [var.sg_id]
  subnet_id              =  var.private_subnet_id

  tags = {
    Instance = "Bastion"
    Terraform   = "true"
    Environment = "dev"
  }
}