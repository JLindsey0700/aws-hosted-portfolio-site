resource "aws_iam_role" "ec2_iam_role" {
  name = "ec2_role_s3"

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

resource "aws_iam_role_policy" "ec2_role_policy" {
  name = "test_policy"
  role = aws_iam_role.ec2_iam_role.id

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = <<EOF
  { 
    "Version" = "2012-10-17"
    "Statement" = [
      {
        "Effect" = "Allow"
        "Action": [
          "s3:*",
        ]
        "Effect"   = "Allow"
        "Resource" = "arn:aws:s3:::web-files-2343"
      },
      {
        "Effect" = "Allow"
        "Action" = "s3.ListAllMyBuckets"
        "Resource" = "arn:aws:s3:::*"
      }
    ]
    EOF
  }
  