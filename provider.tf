terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = var.region
  # Uses a shared credentials file to authenticate with AWS, this ensures my access credentials do not get made public on Github
  shared_credentials_files = ["/home/james/.aws/credentials"] # 
  profile = "iamadmin"
}