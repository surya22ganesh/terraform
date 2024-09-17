resource "aws_instance" "my_ec2" {
  ami ="ami-05134c8ef96964280"
  instance_type = "t2.micro"
  key_name = "oregon-sep-pem"
  vpc_security_group_ids = [ "sg-0ea093ca876124df8" ]  
  
  connection {
    type = "ssh"
    host = self.public_ip
    user = "ubuntu"
    private_key = file("oregon-sep-pem.pem")
    timeout = "4m"
  }

  # file provisioner
#   provisioner "file" {
#     source = "sample.txt"
#     destination = "/home/ubuntu/sample.txt"
#   }

  # remote exec
#   provisioner "remote-exec" {
#     inline = [
#         "touch newfile.txt",
#         "echo remote-exec worked > newfile.txt"
#     ]
#   }

    # local exec
    # provisioner "local-exec" {
    #     command = "mkdir newfolder"
    # } 
}


