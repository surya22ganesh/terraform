terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region     = "us-east-2"
  access_key = ""
  secret_key = ""
}


resource "aws_s3_bucket" "s3_bucket" {

  bucket = "surya22testbucket"

  # force_destroy = true   # if true terraform destroy command will delete bucket.

  # object_lock_enabled = false

  tags = {
    Name        = "My S3 bucket"
    Environment = "Dev"
  }

}


resource "aws_s3_bucket_ownership_controls" "s3_bucket_ownership" {
  bucket = aws_s3_bucket.s3_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "example" {
  bucket                  = aws_s3_bucket.s3_bucket.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}


resource "aws_s3_bucket_acl" "s3_bucket_acl" {
  depends_on = [aws_s3_bucket_ownership_controls.s3_bucket_ownership, aws_s3_bucket.s3_bucket]
  bucket     = aws_s3_bucket.s3_bucket.id
  acl        = "public-read"
}


resource "aws_s3_bucket_versioning" "s3_bucket" {
  bucket = aws_s3_bucket.s3_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_dynamodb_table" "basic-dynamodb-table" {
  name         = "terraform-lock"
  billing_mode = "PAY_PER_REQUEST"
  # read_capacity  = 20
  # write_capacity = 20
  # range_key      = "GameTitle"

  hash_key = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

}

resource "aws_instance" "myec2" {
  ami                         = "ami-003932de22c285676"
  instance_type               = "t2.micro"
#   key_name                    = "yourpublickeyname"
  key_name                    = "ohio-june-pem"
  associate_public_ip_address = true
  vpc_security_group_ids      = ["sg-0faf295e520435067"]
}
