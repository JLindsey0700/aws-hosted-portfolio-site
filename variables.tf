variable "region" {
  type = string
  default = "us-east-1"
}

variable "vpc_cidr" {
    type = string
    default = "10.0.0.0/16"
}

variable "pub_a_cidr" {
    type = string
    default = "10.0.0.0/24"
}

variable "pub_b_cidr" {
    type = string
    default = "10.0.1.0/24"
}

variable "priv_a_cidr" {
    type = string
    default = "10.0.2.0/24"
}

variable "priv_b_cidr" {
    type = string
    default = "10.0.3.0/24"
}

variable "availability_zone_a" {
  type = string
  default = "us-east-1a"
}

variable "availability_zone_b" {
  type = string
  default = "us-east-1b"
}

variable "linux_instance_type" {
  type        = string
  description = "EC2 instance type for Linux Server"
  default     = "t2.micro"
}

variable "web_server_ami" {
  type        = string
  description = "EC2 instance type for Linux Server"
  default     = "ami-05fa00d4c63e32376"
}
