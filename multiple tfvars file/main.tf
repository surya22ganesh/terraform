resource "aws_instance" "my_ec2" {
  ami = "ami-085f9c64a9b75eed5"
  instance_type = "t2.micro"
  key_name = "ohio-june-pem"
  tags = {
    Name = var.ec2_env_tag
  }
  root_block_device {
    volume_size = 10
  }
  vpc_security_group_ids = ["sg-0faf295e520435067"]
}

