# S3 Bucket to store Lambda deployment package
resource "aws_s3_bucket" "lambda_bucket" {
  bucket_prefix = "scale-secondary-eks-"
  acl           = "private"
}

# Upload Lambda function code to S3
resource "aws_s3_object" "lambda_code" {
  bucket = aws_s3_bucket.lambda_bucket.id
  key    = "scale_secondary_eks.zip"
  source = "scale_secondary_eks.zip" # Replace with the path to your zipped Lambda code
}

# Create Lambda Role
resource "aws_iam_role" "lambda_execution_role" {
  name = "scale_secondary_eks_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

# Attach Policy to Lambda Role
resource "aws_iam_role_policy_attachment" "lambda_execution_policy" {
  role       = aws_iam_role.lambda_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Create Lambda Function
resource "aws_lambda_function" "scale_secondary_eks" {
  function_name = "scale-secondary-eks"
  role          = aws_iam_role.lambda_execution_role.arn
  handler       = "scale_secondary_eks.lambda_handler"
  runtime       = "python3.9"

  s3_bucket = aws_s3_bucket.lambda_bucket.id
  s3_key    = aws_s3_object.lambda_code.key

  environment {
    variables = {
      # Add any environment variables your Lambda function needs
    }
  }

  tags = {
    Name = "scale-secondary-eks"
  }
}
