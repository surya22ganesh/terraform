provider "aws" {
  region     = "us-east-2"
  access_key = ""
  secret_key = ""
}

resource "aws_instance" "my_sydney_ec2" {

  ami                         = "ami-024ebc7de0fc64e44"
  instance_type               = "t2.micro"
  key_name                    = "ohio-june-pem"
  associate_public_ip_address = true
  user_data                   = file("mobileapp_website.sh")

  tags = {
    Name = "my_ec2"
  }
  vpc_security_group_ids = ["sg-0faf295e520435067"]

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("ohio-june-pem.pem")
    host        = self.public_ip
  }

}

# TARGET GROUP
# TARGET GROUPS are group of instances that runs on similar port no.

resource "aws_lb_target_group" "my_tg_a" { // Target Group A

  name     = "target-group-a"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "vpc-0c3a2d3fcdb9d03d0"

  tags = {
    Name = "applications runs on port 80"
  }

}

// Target group attachment
resource "aws_lb_target_group_attachment" "tg_attachment_a" {

  target_group_arn = aws_lb_target_group.my_tg_a.arn
  target_id        = aws_instance.my_sydney_ec2.id
  port             = 80

}

# APP LOAD BALANCER
resource "aws_lb" "my_alb" {

  name               = "my-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["sg-0faf295e520435067"]
  subnets            = ["subnet-00affbe800bbb844d", "subnet-00b83515d49656498", "subnet-0aa50881838d14673"]

  tags = {
    Environment = "dev"
  }

}

# ALB listerner 
# dns : port -> forwards to tg attached here
resource "aws_lb_listener" "my_alb_listener" {

  load_balancer_arn = aws_lb.my_alb.arn
  port              = "88" #LISTENER PORT
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.my_tg_a.arn
  }

}

# resource "aws_lb_listener_rule" "rule_b" {
#  listener_arn = aws_lb_listener.front_end.arn
#  priority     = 60

#  action {
#    type             = "forward"
#    target_group_arn = aws_lb_target_group.my_app_lb_tg.arn
#  }

#  condition {
#    path_pattern {
#      values = ["/images*"]
#    }
#  }
# }
