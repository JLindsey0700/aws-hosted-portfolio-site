resource "aws_iam_role" "ec2_iam_role" {
  name = "EC2_IAM_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
  tags = {
    tag-key = "ec2_role"
  }
} 
# IAM policy to allow SSM to be used to manage EC2 instances
resource "aws_iam_policy" "SSM_policy" {
  name        = "SSM_policy"
  description = "Policy allowing access to SSM"
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ssm:DescribeAssociation",
                "ssm:GetDeployablePatchSnapshotForInstance",
                "ssm:GetDocument",
                "ssm:DescribeDocument",
                "ssm:GetManifest",
                "ssm:ListAssociations",
                "ssm:ListInstanceAssociations",
                "ssm:PutInventory",
                "ssm:PutComplianceItems",
                "ssm:PutConfigurePackageResult",
                "ssm:UpdateAssociationStatus",
                "ssm:UpdateInstanceAssociationStatus",
                "ssm:UpdateInstanceInformation"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "ssmmessages:CreateControlChannel",
                "ssmmessages:CreateDataChannel",
                "ssmmessages:OpenControlChannel",
                "ssmmessages:OpenDataChannel"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "ec2messages:AcknowledgeMessage",
                "ec2messages:DeleteMessage",
                "ec2messages:FailMessage",
                "ec2messages:GetEndpoint",
                "ec2messages:GetMessages",
                "ec2messages:SendReply"
            ],
            "Resource": "*"
        }
    ]
  })
}
# IAM policy to allow S3 bucket hosting website files to be accessed
resource "aws_iam_policy" "S3_policy" {
  name        = "S3_policy"
  description = "Allows access to S3 hosting website files"
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action = [
                "s3:PutObject",
                "s3:GetObject",
                "s3:PutObjectAcl",
                "s3:DeleteObject",
                "s3:ListBucket"
        ],
        Resource = [
                    "arn:aws:s3:::web-files-2343",
                    "arn:aws:s3:::web-files-2343/*"
        ]
      },
    ]
  })
}

#Attaches SSM policy to EC2 IAM role
resource "aws_iam_policy_attachment" "SSM_policy_attachment" {
  name       = "SSM_policy_attachment"
  roles      = [aws_iam_role.ec2_iam_role.name]
  policy_arn = aws_iam_policy.SSM_policy.arn
}
# Attaches S3 policy to EC2 IAM role
resource "aws_iam_policy_attachment" "S3_policy_attachment" {
  name       = "S3_policy_attachment" 
  roles      = [aws_iam_role.ec2_iam_role.name]
  policy_arn = aws_iam_policy.S3_policy.arn
}

# Assings the predefined EC2 role to the EC2 IAM instance profile which is assigned to the web server
resource "aws_iam_instance_profile" "webserver_role" {
  name = "ec2_role_access_s3"
  role = aws_iam_role.ec2_iam_role.name
}