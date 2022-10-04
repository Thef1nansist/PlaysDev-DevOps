variable "db_password" {
  description = "RDS root user password"
  type        = string
  default = "qewadszcx"
}

variable "private_db_subnets" {}

variable "security_group_private_id" {}

variable "azs" {}
