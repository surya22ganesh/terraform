locals {
  environment = "test-env"
}

resource "aws_instance" "myec2_client" {
  ami = "ami-085f9c64a9b75eed5"
  instance_type = "t2.micro"
  key_name = "my-pem-key"
  tags = {
    Name = "${local.environment}-ec2"  #replaced as test-env-ec2 
  }
  root_block_device {
    volume_size = 22
  }
  vpc_security_group_ids = ["sg-0faf295e520435067"]
}

resource "aws_vpc" "test_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "${local.environment}-vpc" # replaced as test-env-vpc
  }
}

# locals are variables
