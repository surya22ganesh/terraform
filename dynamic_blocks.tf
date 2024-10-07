resource "aws_instance" "my_ec2" {
  ami = "ami-04dd23e62ed049936"
  instance_type = "t2.micro"
  vpc_security_group_ids = [ aws_security_group.my_ec2_tf_sg.id ]
  tags = {
    Name = "my-ec2"
  }
}

locals {
 
 ingress_rule = [
    {
        port = 22
    },
    {
        port = 443
    },
    {
        port = 80
    },
  ]

}

resource "aws_security_group" "my_ec2_tf_sg" {
  name   = "my-sg-rule-tf"
  vpc_id = "vpc-0d182a4e7b600e301"
  tags = {
    Name = "my_ec2_tf_sg"
  }

  dynamic "ingress"{
    for_each = local.ingress_rule

    content {
        from_port        = ingress.value.port
        to_port          = ingress.value.port
        protocol         = "tcp"
        cidr_blocks      = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
    }
  }

  egress = [
    {
        from_port        = 0
        to_port          = 0
        protocol         = "-1"
        cidr_blocks      = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
        description = ""
        prefix_list_ids = []
        security_groups = []
        self = false
    }
  ]

}
