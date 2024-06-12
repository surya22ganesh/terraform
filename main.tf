provider "aws" {
  region = "us-east-2"
}

resource "aws_key_pair" "Keypair" {
  key_name = "pubkey"
  public_key = file("mykey.pub")
}

resource "aws_instance" "myinstance" {
  
  instance_type = "t2.micro"
  ami = "ami-0c9921088121ad00b"
  key_name = "pubkey"  
  vpc_security_group_ids = [ 
    "sg-0faf295e520435067"
   ]
#   security_groups = [ sg-0faf295e520435067 ]
  tags = {
    Name = "ec-2 server"
  }
    
}

