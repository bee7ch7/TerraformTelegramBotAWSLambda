resource "aws_s3_bucket" "telegramweatherbucket" {
  bucket = "telegramweatherbucket"

  tags = {
    Name        = "telegramweatherbucket"
    Environment = "Prod"
  }
}

resource "aws_s3_bucket_acl" "acl" {
  bucket = aws_s3_bucket.telegramweatherbucket.id
  acl    = "private"
}