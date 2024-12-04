
resource "aws_ecr_repository" "react_app" {
  name                 = "react-app-repo"
  image_tag_mutability = "MUTABLE"
  force_delete = false

  image_scanning_configuration {
    scan_on_push = true
  }
  tags = {
    Environment = var.environment
    Service = "frontend"
  }
}

resource "aws_ecr_repository" "cart_service" {
  name = "${var.environment}-cart-service"
  force_delete = false
  
  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Environment = var.environment
    Service     = "microservice"
    Type        = "cart-service"
  }
}

resource "aws_iam_policy" "ecr_policy" {
  name        = "ecr-access-policy"
  description = "Policy for ECR repository access"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:BatchCheckLayerAvailability",
          "ecr:PutImage",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload",
          "ecr:GetAuthorizationToken"
        ]
        Resource = [aws_ecr_repository.react_app.arn]
      },
      {
        Effect = "Allow"
        Action = ["ecr:GetAuthorizationToken"]
        Resource = ["*"]
      }
    ]
  })
}


resource "aws_iam_role_policy" "ecr_full_access" {
  name = "${var.environment}-ecr-full-access"
  role = aws_iam_role.eks_nodes.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ecr:BatchCheckLayerAvailability",
          "ecr:BatchGetImage",
          "ecr:GetDownloadUrlForLayer",
          "ecr:GetAuthorizationToken",
          "ecr:CompleteLayerUpload",
          "ecr:InitiateLayerUpload",
          "ecr:PutImage",
          "ecr:UploadLayerPart"
        ]
        Resource = "*"
      }
    ]
  })
}

# Add policy for the user/role executing the deployment script
resource "aws_iam_policy" "ecr_deploy_policy" {
  name        = "${var.environment}-ecr-deploy-policy"
  description = "Policy for ECR image deployment"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:GetRepositoryPolicy",
          "ecr:DescribeRepositories",
          "ecr:ListImages",
          "ecr:DescribeImages",
          "ecr:BatchGetImage",
          "ecr:PutImage",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_ecr_lifecycle_policy" "react_app" {
  repository = aws_ecr_repository.react_app.name

  policy = jsonencode({
    rules = [{
      rulePriority = 1
      description  = "Keep last 5 images"
      selection = {
        tagStatus     = "any"
        countType     = "imageCountMoreThan"
        countNumber   = 5
      }
      action = {
        type = "expire"
      }
    }]
  })
}

output "ecr_repository_url" {
  value = aws_ecr_repository.react_app.repository_url
}

output "cart_service_repository_url" {
  value = aws_ecr_repository.cart_service.repository_url
}
