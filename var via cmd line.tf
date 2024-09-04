variable "ec2_instance_type" {
  description = "ec2 type"
  type = string
}

resource "aws_instance" "k8s_client" {
  ami = "ami-085f9c64a9b75eed5"
  instance_type = var.ec2_instance_type
  key_name = ""
  tags = {
    Name = "ec2"
  }
  root_block_device {
    volume_size = 10
  }
  vpc_security_group_ids = ["sg-0faf295e520435067"]
}

# Here var.ec2_instance_type doesnt have a default value 

# To provide a value via command line use below commands

# 1) terraform plan -var="ec2_instance_type=t2.micro" 

# 2) terraform apply -var="ec2_instance_type=t2.micro"

#NOTE:

#Even If default value is provided to variable, providing a value via command line -var will over write default value of a varaible.
