# AWS Hosted Portfolio Site

## Objective
The goal of this project is to host my personal portfolio website page on AWS. The site can be accessed via [jameslindsey.link](http://jameslindsey.link)

## Alternatives
There are many simplier way to host a basic static website, I could have uploaded my web content to S3, or even used GitHub Pages. The aim of the project was to test myself to deploy a highly available, performant web server that could scale based on the resource utilization, and could survive the failure of an underlying infrastructure component, and  could be intergrated with my own registered domain name.

## Infrastructure Components
- The web servers serving the web content is hosted on AWS EC2 instances running Amazon Linux. 
- The instances are deployed using a launch configuration and an Auto Scaling Group.
- Every time an instance in launched it retrieves the website content files from a S3 bucket, which are copied into the Apache default document root (var/www/html).
- An Application Load Balancer is attached to the Target Group of the the Web Server instances.
- An A record is created in the R53 hosted zone for my pre-registered domain name which routes route traffic to the DNS name of the ALB.

## Infrastructure Features
- The Auto Scaling Group enables the web server to scale performance using a dynamic scaling policy that monitors the CPU utilization of the instances.
- The Application Load Balanacer ensures the traffic is distributed across at at least two instances, providing high availability.
- The Security Groups & IAM roles are constructed to adhere to the principle of least privledge, only accepting traffic from the nessecary ports & only requiring access to the S3 buckets required to fetch the web content.
