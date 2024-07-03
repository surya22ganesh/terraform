provider "aws" {
  region = "us-east-2"
  access_key = ""
  secret_key = ""
}

resource "tls_private_key" "priv_key" {
  algorithm = "RSA"
  rsa_bits = "2048"
}

resource "aws_key_pair" "key_pair" {
  public_key = tls_private_key.priv_key.public_key_openssh
  key_name = "mypublickey"
}

resource "local_file" "local_file_download" {
  content = tls_private_key.priv_key.private_key_pem
  filename = "downloadedprivkey"
}

resource "aws_instance" "ec2" {
  instance_type = "t2.micro"
  ami = "ami-0edf386e462400a51"
  key_name = aws_key_pair.key_pair.key_name
  tags = {
    Name = "my_ec2"
  }
}

