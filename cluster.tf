resource "aws_security_group" "allow_rabbitmq" {
  name        = "roboshop-rabbitmq-${var.ENV}"
  description = "roboshop-rabbitmq-${var.ENV}"
  vpc_id      = data.terraform_remote_state.vpc.outputs.VPC_ID

  ingress {
    description = "TLS from VPC"
    from_port   = var.RABBITMQ_PORT
    to_port     = var.RABBITMQ_PORT
    protocol    = "tcp"
    cidr_blocks = [data.terraform_remote_state.vpc.outputs.VPC_CIDR]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "roboshop-rabbitmq-${var.ENV}"
  }
}

resource "aws_mq_broker" "rabbitmq" {
  broker_name = "roboshop-${var.ENV}"


  engine_type        = "RabbitMQ"
  engine_version     = var.RABBITMQ_ENGINE_VERSION
  host_instance_type = var.RABBITMQ_INSTANCE_TYPE
  security_groups    = [aws_security_group.allow_rabbitmq.id]
  subnet_ids         = [data.terraform_remote_state.vpc.outputs.PRIVATE_SUBNET_IDS[0]]

  user {
    username = jsondecode(data.aws_secretsmanager_secret_version.secrets.secret_string)["RABBITMQ_USERNAME"]
    password = jsondecode(data.aws_secretsmanager_secret_version.secrets.secret_string)["RABBITMQ_PASSWORD"]
  }
}
