# static-website-ec2
This website is hosted on a minimun of two EC2 instances, which are deployed using a launch configuration using an Auto Scaling Group.\
The instances retrieve the web content from a S3 bucket, which is then copied into their var/www/html files where Apache serves the web content to the users.\
An Application Load Balancer is attached to the Target Group of the the Web Server instances.\
An A record is created which assosiates the DNS name of the Application Load Balancer with the hosted zone of a pre-registered domain name (jameslindsey.link)\

The Auto Scaling Group enables the web server to scale performance using a dynamic scaling policy that monitors the CPU utilization of the instances.\
The Application Load Balanacer ensures the traffic is distributed across at at least two instances, providing high availability.\
The Security Groups & IAM roles are constructed to adhere to the principle of least privledge, only accepting traffic from the nessecary ports & only requiring access to the S3 buckets required to fetch the web content.\