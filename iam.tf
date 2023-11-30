resource "aws_iam_role" "ec2_iam_role" {
  name = "EC2_IAM_role"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
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
#Defines the IAM policy to allow SSM to be used to manage the EC2
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
#Defines the IAM policy to allow S3 to be accessed, need to refine to particular buckets and actions to improve security posture
resource "aws_iam_policy" "S3_policy" {
  name        = "S3_policy"
  description = "Policy allowing access to S3"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:*",
        ]
        Effect   = "Allow"
        Resource = "*"
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
#Attaches S3 policy to EC2 IAM role
resource "aws_iam_policy_attachment" "S3_policy_attachment" {
  name       = "S3_policy_attachment" 
  roles      = [aws_iam_role.ec2_iam_role.name]
  policy_arn = aws_iam_policy.S3_policy.arn
}

# Assings the prefined ec2 role to the ec2 iam instance profile which is assigned to the web server
resource "aws_iam_instance_profile" "webserver_role" {
  name = "ec2_role_access_s3"
  role = aws_iam_role.ec2_iam_role.name
}