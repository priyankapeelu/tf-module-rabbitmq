data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "terraformd63"
    key    = "vpc/${var.ENV}/terraform.tfstate"
    region = "us-east-1"
  }
}


data "aws_secretsmanager_secret" "secrets" {
  name = "${var.ENV}/roboshop/secret"
}

data "aws_secretsmanager_secret_version" "secrets" {
  secret_id = data.aws_secretsmanager_secret.secrets.id
}

mongo --ssl --sslCAFile /home/centos/rds-combined-ca-bundle.pem --host roboshop-dev.cluster-cunmblsnrv4v.us-east-1.docdb.amazonaws.com --username admin1 --password roboshop1 < catalogue.js
mongo --ssl --sslCAFile /home/centos/rds-combined-ca-bundle.pem --host roboshop-dev.cluster-cunmblsnrv4v.us-east-1.docdb.amazonaws.com --username admin1 --password roboshop1  < users.js