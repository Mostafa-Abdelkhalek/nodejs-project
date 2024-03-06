resource "aws_ecr_repository" "repo" {
  name                 = "nodejs"
  image_scanning_configuration {
    scan_on_push = true
  }
}