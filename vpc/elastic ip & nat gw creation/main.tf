provider "aws" {
  region = "us-east-2"
  access_key = ""
  secret_key = ""
}


resource "aws_eip" "my_eip" {
  
  tags = {
    #name for our elastic IP
    Name = "my_eip1"
  }

}

resource "aws_nat_gateway" "my_nat" {

  # elastic IP allocated here   
  allocation_id = aws_eip.my_eip.id

  # subnet ID  
  subnet_id = "subnet-00b83515d49656498"
  
  depends_on = [ aws_eip.my_eip ]
  
  #meta data
  tags = {
    Name = "my_nat_gw"
  }
}


