variable "region" {
  type = string
  description = "AWS region"
  default = "us-east-1"
}

variable "vpc_cidr" {
    type = string
    description = "CIDR range for VPC"
    default = "10.0.0.0/16"
}

variable "pub_a_cidr" {
    type = string
    description = "CIDR range for public subnet a"
    default = "10.0.0.0/24"
}

variable "pub_b_cidr" {
    type = string
    description = "CIDR range for public subnet b"
    default = "10.0.1.0/24"
}

variable "priv_a_cidr" {
    type = string
    description = "CIDR range for private subnet a"
    default = "10.0.2.0/24"
}

variable "priv_b_cidr" {
    type = string
    description = "CIDR range for private subnet b"
    default = "10.0.3.0/24"
}

variable "availability_zone_a" {
  type = string
  description = "Availabilty zone for AZ-A"
  default = "us-east-1a"
}

variable "availability_zone_b" {
  type = string
  description = "Availabilty zone for AZ-B"
  default = "us-east-1b"
}

variable "linux_instance_type" {
  type        = string
  description = "EC2 instance type for Linux Server"
  default     = "t2.micro"
}

variable "web_server_ami" {
  type        = string
  description = "Ami ID for launch configuration"
  default     = "ami-05fa00d4c63e32376"
}

variable "domain_name" {
  type        = string
  description = "Registered domain name"
  default     = "jameslindsey.link"
}

