// Primary ECR Repository: react_app
resource "aws_ecr_repository" "react_app" {
  name                 = "react-app-repo"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Environment = var.environment
    Service     = "frontend"
  }

  lifecycle {
    ignore_changes = [name]  # This will ignore changes to the 'name' attribute of the ECR repository
  }
}

// Secondary ECR Repository: react_app_secondary
resource "aws_ecr_repository" "react_app_secondary" {
  provider             = aws.secondary
  name                 = "react-app-repo-secondary"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Environment = var.environment
    Service     = "frontend-secondary"
  }

  lifecycle {
    ignore_changes = [name]  # This will ignore changes to the 'name' attribute of the ECR repository
  }
}

// Primary ECR Repository: cart_service
resource "aws_ecr_repository" "cart_service" {
  name = "${var.environment}-cart-service"
  
  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Environment = var.environment
    Service     = "microservice"
    Type        = "cart-service"
  }

  lifecycle {
    ignore_changes = [name]  # This will ignore changes to the 'name' attribute of the ECR repository
  }
}

// Secondary ECR Repository: cart_service_secondary
resource "aws_ecr_repository" "cart_service_secondary" {
  provider = aws.secondary
  name     = "${var.environment}-cart_service_secondary"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Environment = var.environment
    Service     = "microservice_secondary"
    Type        = "cart-service_secondary"
  }

  lifecycle {
    ignore_changes = [name]  # This will ignore changes to the 'name' attribute of the ECR repository
  }
}

// IAM Policy for ECR Access
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

  lifecycle {
    ignore_changes = [name]  # Ignore changes to the 'name' of the IAM policy
  }
}

// IAM Role Policy for ECR Full Access
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

// IAM Policy for ECR Deployment
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

// ECR Lifecycle Policy for Primary Repository: react_app
resource "aws_ecr_lifecycle_policy" "react_app" {
  repository = aws_ecr_repository.react_app.name

  policy = jsonencode({
    rules = [ {
      rulePriority = 1
      description  = "Keep last 5 images"
      selection = {
        tagStatus   = "any"
        countType   = "imageCountMoreThan"
        countNumber = 5
      }
      action = {
        type = "expire"
      }
    }]
  })
}

// ECR Lifecycle Policy for Secondary Repository: react_app_secondary
resource "aws_ecr_lifecycle_policy" "react_app_secondary" {
  provider   = aws.secondary
  repository = aws_ecr_repository.react_app_secondary.name

  policy = jsonencode({
    rules = [ {
      rulePriority = 1
      description  = "Keep last 5 images"
      selection = {
        tagStatus   = "any"
        countType   = "imageCountMoreThan"
        countNumber = 5
      }
      action = {
        type = "expire"
      }
    }]
  })
}
