terraform {
  backend "s3" {
    bucket = "surya22testbucket"
    key    = "tfstatefile/terraform.tfstate"
    region = "us-east-2"
    dynamodb_table = "terraform-lock"
  }
}
