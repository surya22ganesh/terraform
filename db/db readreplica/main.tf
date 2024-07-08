provider "aws" {
  region     = "us-east-2"
  access_key = ""
  secret_key = ""
}

resource "aws_db_instance" "my_db" {

  allocated_storage = 20
  identifier        = "ee-instance-demo"

  #when DB is created initial database named initialdb will be created; show databases; 
  db_name = "initialdb"

  engine         = "mysql"
  engine_version = "8.0"
  instance_class = "db.t3.micro"

  # user name and password for database
  username = "suryadb"
  password = "surya123"

  #   parameter_group_name   = "default.mysql8.0"
  skip_final_snapshot = true
  multi_az            = false
  publicly_accessible = true

  # security group for DB
  vpc_security_group_ids  = ["sg-0faf295e520435067"]
  port                    = 3306
  backup_retention_period = 7
}


# Read Replica for DB

resource "aws_db_instance" "test-replica" {
  
  # source data base
  replicate_source_db = aws_db_instance.my_db.identifier
  
  #   replica_mode               = "mounted"
  #   auto_minor_version_upgrade = false
  #   custom_iam_instance_profile = "AWSRDSCustomInstanceProfile" # Instance profile is required for Custom for Oracle. See: https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/custom-setup-orcl.html#custom-setup-orcl.iam-vpc
  backup_retention_period = 7
  identifier              = "ee-instance-replica"
  instance_class          = "db.t3.micro"
  #   kms_key_id                  = data.aws_kms_key.by_id.arn
  multi_az            = false # Custom for Oracle does not support multi-az
  skip_final_snapshot = true
  #   storage_encrypted   = true

  # timeouts {
  #   create = "3h"
  #   delete = "3h"
  #   update = "3h"
  # }

}

