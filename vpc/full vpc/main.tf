provider "aws" {
  region     = "us-east-2"
  access_key = ""
  secret_key = ""
}

resource "aws_vpc" "vpc" {

  # cidr block for vpc
  cidr_block = "10.0.0.0/16"

  # metadata
  tags = {
    Name = "my_vpc"
  }

}

resource "aws_internet_gateway" "my_igw" {

  tags = {
    Name = "my_igw"
  }

}

resource "aws_internet_gateway_attachment" "name" {

  # attaching igw to vpc 
  vpc_id = aws_vpc.vpc.id
  
  internet_gateway_id = aws_internet_gateway.my_igw.id

}

resource "aws_subnet" "public_subnet" {

  # cidr block for public subnet
  cidr_block = "10.0.1.0/24"

  # vpc_id attachment
  vpc_id = aws_vpc.vpc.id

  # map public ip 
  map_public_ip_on_launch = true

}

resource "aws_subnet" "private_subnet" {
  # cidr block for public subnet
  cidr_block = "10.0.2.0/24"

  # vpc_id attachment
  vpc_id = aws_vpc.vpc.id

  # map public ip 
  map_public_ip_on_launch = false

}

resource "aws_route_table" "public_rt" {
  
  vpc_id = aws_vpc.vpc.id

  route {

    # public RT cidr block  
    cidr_block = "0.0.0.0/0"
    
    #internet gateway
    gateway_id = aws_internet_gateway.my_igw.id
  
  }

  tags = {

    Name = "public RT"
  
  }

}

resource "aws_route_table_association" "public_rt_association" {

  route_table_id = aws_route_table.public_rt.id

  subnet_id = aws_subnet.public_subnet.id

}

# creating elastic IP
resource "aws_eip" "eip" {
  tags = {
    Name = "my_elastic_ip"
  }
}

# creating NAT GW
resource "aws_nat_gateway" "my_nat_gw" {
  allocation_id = aws_eip.eip.id
  subnet_id = aws_subnet.private_subnet.id
  depends_on = [ aws_eip.eip ]
}


# resource "aws_route_table" "private_rt" {
  
  resource "aws_route_table" "private_rt" {
  
  vpc_id = aws_vpc.vpc.id

  route {

    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.my_nat_gw.id
  
  }

  tags = {
    Name = "private_rt"
  }
}

resource "aws_route_table_association" "private_rt_association" {

  route_table_id = aws_route_table.private_rt.id

  subnet_id = aws_subnet.private_subnet.id

}

resource "aws_security_group" "my_security_group" {
  
  vpc_id = aws_vpc.vpc.id

  tags = {

    Name = "TERRAFORM_ALL_TCP"
  
  }

}

resource "aws_vpc_security_group_ingress_rule" "example" {
  security_group_id = aws_security_group.my_security_group.id
  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 0
  ip_protocol = "tcp"
  to_port     = 65535
}

resource "aws_vpc_security_group_egress_rule" "example" {
  security_group_id = aws_security_group.my_security_group.id
  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 0
  ip_protocol = "tcp"
  to_port     = 65535
}

resource "aws_instance" "my_ec2" {
  
  ami = "ami-024ebc7de0fc64e44"
  
  instance_type = "t2.micro"

  security_groups = [ aws_security_group.my_security_group.id ]

  # public key is attched here.
  # check available public keys in ec2 -> Network & security -> Key Pairs. 
  key_name = "ohio-june-pem"
  
  subnet_id = aws_subnet.public_subnet.id

  associate_public_ip_address = true
  
  tags = {
    Name = "my-public-subnet-ec2"
  }

}

resource "aws_instance" "my_ec2_priv" {
  
  ami = "ami-024ebc7de0fc64e44"
  
  instance_type = "t2.micro"

  security_groups = [ aws_security_group.my_security_group.id ]

  key_name = "ohio-june-pem"

  subnet_id = aws_subnet.private_subnet.id

  associate_public_ip_address = false
  
  tags = {
    Name = "my-private-subnet-ec2"
  }
  
}