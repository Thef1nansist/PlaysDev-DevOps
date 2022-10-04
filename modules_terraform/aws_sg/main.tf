resource "aws_security_group" "public" {
  name = "public-sg"
  description = "Public internet access"
  vpc_id = var.vpc_id
 
  tags = {
    Name        = "public-sg"
    Role        = "public"
    ManagedBy   = "terraform"
  }
}
 
resource "aws_security_group_rule" "public_out" {
  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
 
  security_group_id = aws_security_group.public.id
}
 
resource "aws_security_group_rule" "public_in_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.public.id
}
 
###
# Private Security Group
##
 
resource "aws_security_group" "private" {
  name = "private-sg"
  description = "Private internet access"
  vpc_id = var.vpc_id
 
  tags = {
    Name        = "private-sg"
    Role        = "private"
    ManagedBy   = "terraform"
  }
}
 
resource "aws_security_group_rule" "private_out" {
  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
 
  security_group_id = aws_security_group.private.id
}
 
resource "aws_security_group_rule" "private_in" {
  type              = "ingress"
  from_port         = 5432
  to_port           = 5432
  protocol          = "tcp"
  cidr_blocks = [var.vpc_cidr]
 
  security_group_id = aws_security_group.private.id
}