
resource "aws_ecr_repository" "lambda_images" {
  name = var.name
  image_tag_mutability = "MUTABLE"
  
  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_lifecycle_policy" "lambda_images_lifecycle_policy" {
  repository = aws_ecr_repository.lambda_images.name
  
  policy = <<EOF
{
  "rules": [
    {
      "rulePriority": 1,
      "description": "Expire all untagged images",
      "selection": {
        "tagStatus": "untagged",
        "countType": "sinceImagePushed",
        "countUnit": "days",
        "countNumber": 1
      },
      "action": {
        "type": "expire"
      }
    }
  ]
}
EOF
}
