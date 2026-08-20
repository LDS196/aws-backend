resource "aws_ecr_repository" "backend" {
  name                 = "devops-backend-api"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = false
  }

  tags = {
    Name = "devops-backend-api"
  }
}