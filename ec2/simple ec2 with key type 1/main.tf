provider "aws" {
  region = "us-east-2"
  access_key = ""
  secret_key = ""
}

resource "aws_key_pair" "name" {
  public_key = file("terrakey.pub")
  key_name = "terrakeypublic"
}

resource "aws_instance" "ec2" {
  instance_type = "t2.micro"
  ami = "ami-0edf386e462400a51"
  key_name = aws_key_pair.name.key_name
  tags = {
    Name = "my_ec2"
  }
}

