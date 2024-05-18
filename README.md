# AWS Hosted Portfolio Site

## Objective
The objective of this project is to deploy and host my portfolio website on AWS cloud infrastructure. The project aim is to deploy a robust, highly available, and scalable web server that can withstand infrastructure failures and integrate with a custom registered domain name.

## Infrastructure Components
- **AWS EC2 Instances**: Hosting the Apache web servers running on Linux (Amazon Linux 2).
- **Networking**: VPC architecture with segregated public and private subnets, an Internet Gateway for external connectivity, and NAT Gateways allowing secure internet access within the private subnets. 
- **Launch Configuration & Auto Scaling Group**: Utilized for deploying instances and managing scaling based on demand.
- **S3 Bucket**: Storing the website content files, fetched by instances during boot and copied into the Apache default document root (var/www/html).
- **Application Load Balancer (ALB)**: Attached to the Target Group of the web server instances, distributing incoming traffic.
- **Route 53 (R53)**: Creating an Alias record in the Route53 hosted zone for the pre-registered domain name and routing traffic to the load balancer DNS name.

## Infrastructure Features
- **Dynamic Scaling**: Auto Scaling Group uses a dynamic scaling policy that monitors CPU utilization of the EC2 instances to scale out web server performance as needed.
- **High Availability**: Application Load Balancer ensures traffic distribution across at least two instances, ensuring high availability and fault tolerance.
- **Security Measures**: Implementation of Security Groups & IAM roles follow the principle of least privilege, restricting traffic to necessary ports and providing limited access only to required S3 buckets hosting website files.

## Automation
Alongside the infrastructure deployment automation achieved using Terraform, this project uses bash scripting to bootstrap the EC2 instances during start-up, to prepare each instance to act as a web server. The script I've created can be seen below and is referenced with the asg.tf file.
```
#!/bin/bash
yum update -y                         
yum install -y httpd.x86_64           
sudo systemctl start httpd.service  
sudo systemctl enable httpd.service
sudo aws s3 cp s3://web-files-2343/ /var/www/html/ --recursive 
```
## Future Integration and Growth

This project's infrastructure setup serves as a foundation that can evolve and integrate into more complex architectures. As the project advances it provides the groundwork for incorporating more layers, such as database servers, caching layers, and application servers, potentially evolving into a three-tier or a LAMP stack.

By starting with a scalable and well-architected foundation, this project not only fulfils its current hosting needs but also acts as a stepping stone for future growth and learning.

## Alternatives
While several more straightforward methods exist to host a static website, like uploading web files to S3 or using GitHub Pages, the emphasis on deploying web servers through EC2 instances, utilizing Auto Scaling Groups, leveraging Application Load Balancers, and managing content through S3 buckets aligns with enterprise-grade IT architecture designs. These practices ensure high availability, fault tolerance, scalability, and efficient resource utilization, reflecting the principles commonly seen in large-scale, mission-critical apps.
