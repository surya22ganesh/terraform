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

resource "aws_instance" "myec2" {
  ami = "ami-003932de22c285676"
  instance_type = "t2.micro"
  key_name = "ohio-june-pem"
  associate_public_ip_address = true
  vpc_security_group_ids = [ "sg-0faf295e520435067" ]
  tags = {
    Name = "website"
    port = "80"
  }

  connection {
    type = "ssh"
    port = 22
    user = "ubuntu"
    private_key = file("yourPrivKey")
    host = self.public_ip
  }

  provisioner "file" {
    source = "docker"
    destination = "."
  }
  
  user_data = file("userdatav2.sh")
       
}