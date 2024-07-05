provider "aws" {
  region     = "us-east-2"
  access_key = ""
  secret_key = ""
}

resource "aws_s3_bucket" "my_s3_bucket" {
  
  # Bucket name
  bucket = "surya-bucket-tf-2"
  
  # Meta data
  tags = {
    Name = "surya-tf-bucket-1"
  }
}

resource "aws_s3_bucket_public_access_block" "s3_public_access" {
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
  bucket = aws_s3_bucket.my_s3_bucket.id
}

resource "aws_s3_bucket_ownership_controls" "s3_bucket_ownership_controls" {
  
  bucket = aws_s3_bucket.my_s3_bucket.id
  
  # Available values are "BucketOwnerPreferred" "ObjectWriter" "BucketOwnerEnforced"]
  # the ACL'S can be given only when object_ownership = "BucketOwnerPreferred"
  rule {
    object_ownership = "BucketOwnerPreferred"
  }

}

resource "aws_s3_bucket_acl" "bucket_acl" {

    depends_on = [
    aws_s3_bucket_ownership_controls.s3_bucket_ownership_controls,
    aws_s3_bucket_public_access_block.s3_public_access,
  ]

  bucket = aws_s3_bucket.my_s3_bucket.id

  acl    = "public-read-write"

}

# Object or File
resource "aws_s3_object" "my_s3_object" {
  
  bucket = aws_s3_bucket.my_s3_bucket.id
  
  # Object Name 
  key    = "this is a document2.txt"
  
  # Object 
  source = "sample1.txt"
  
  # Permissions for Object
  acl = "public-read-write"

  # etag = filemd5("sample1.txt")

}


