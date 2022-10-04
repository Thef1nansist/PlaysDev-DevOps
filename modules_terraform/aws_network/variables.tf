variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "az_number" {
  default = {
    a = 1
    b = 2
    c = 3
  }
}
variable aws_region { 
  default = "us-east-1" 
  }

variable aws_azs {
  default = {
    us-east-1 = "us-east-1a,us-east-1c,us-east-1d"
  }
}

variable "env" {
  default = "dev"
}

variable "public_subnet_cidrs" {
  default = [
    "10.0.11.0/24",
    "10.0.21.0/24"
    ]
}

variable "private_subnet_cidrs" {
    default = [
    "10.0.12.0/24",

    "10.0.22.0/24",

    ]
}

variable "private_subnet_db_cidrs" {
  default = [
    "10.0.13.0/24",
    "10.0.23.0/24",
    "10.0.33.0/24"
  ]
}