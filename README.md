# AWS Hosted Portfolio Site

## Objective
The objective of this project is to deploy and host my portfolio website on AWS cloud infrastructure. The project aims deploy a robust, highly available, and scalable web server that can withstand infrastructure failures and seamlessly integrates with a custom registered domain name.

## Alternatives
While several straightforward methods exist to host a basic static website (e.g. uploading website files to S3 or using GitHub Pages) this project pursues a more comprehensive challenge. The emphasis on deploying web servers through EC2 instances, utilizing Auto Scaling Groups, leveraging Application Load Balancers, and managing content through S3 buckets aligns with enterprise-grade architectural paradigms. These practices ensure high availability, fault tolerance, scalability, and efficient resource utilization, reflecting the principles commonly employed in large-scale, mission-critical apps.

## Architecture Diagram





## Infrastructure Components
- **AWS EC2 Instances**: Hosting the Apache web servers running on Linux (Amazon 2).
- **Networking**: VPC architecture with segregated public and private subnets, an Internet Gateway for external connectivity, and NAT Gateways allowing secure internet access within the private networks. 
- **Launch Configuration & Auto Scaling Group**: Utilized for deploying instances and managing scaling based on demand.
- **S3 Bucket**: Storing the website content files, fetched by instances during launch and copied into the Apache default document root (var/www/html).
- **Application Load Balancer (ALB)**: Attached to the Target Group of the Web Server instances, distributing incoming traffic efficiently.
- **Route 53 (R53)**: Creating an Alias record in the Route53 hosted zone for the pre-registered domain name and routing traffic to the load balancer DNS name.

## Infrastructure Features
- **Dynamic Scaling**: Auto Scaling Group uses a dynamic scaling policy monitoring CPU utilization to scale web server performance as needed.
- **High Availability**: Application Load Balancer ensures traffic distribution across at least two instances, ensuring high availability and fault tolerance.
- **Security Measures**: Implementation of Security Groups & IAM roles follow the principle of least privilege, restricting traffic to necessary ports and providing limited access only to required S3 buckets housing web content.

## Future Integration and Growth

This project's infrastructure setup serves as a foundational framework that can evolve and integrate seamlessly into more complex architectures. As the project advances, it providestthe groundwork for incorporating additional layers, such as database servers, caching layers, and application servers—eventually evolving into a three-tier or a LAMP stack architecture.

By starting with a scalable and well-architected foundation, this project not only fulfills its immediate hosting needs but also acts as a stepping stone for future expansion and learning. It offers the opportunity to explore and implement more advanced architectures, enabling a deeper understanding of how to design, deploy, and manage sophisticated systems in the cloud.