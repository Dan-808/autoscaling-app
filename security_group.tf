resource "aws_security_group" "web" { #esse SG aceita connexão da internet, resposavel por recebr requisições vão srrereonaas para as
  name        = "Web"
  description = "Allow public inbound traffic"
  vpc_id      = aws_vpc.my-vpc.id

  ingress {
    from_port = 80 #http

    to_port = 80

    protocol = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 443 #https

    to_port = 443

    protocol = "tcp"

    cidr_blocks = ["0.0.0.0/0"]


  }

  ingress {
    from_port = -1 #https

    to_port = -1

    protocol = "icmp"

    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {

    from_port = 3306

    to_port = 3306

    protocol = "tcp"

    cidr_blocks = [aws_subnet.this["pvt_a"].cidr_block]

  }

  ingress {
    from_port = 22

    to_port = 22

    protocol = "tcp"

    cidr_blocks = ["201.87.95.134/32"]
  }

  tags = {
    Name = "Web server"
  }

}

resource "aws_security_group" "db" {
  name        = "DB"
  description = "Allow incoming database connections"
  vpc_id      = aws_vpc.my-vpc.id

  ingress {
    from_port = 3306 #http

    to_port = 3306

    protocol = "tcp"

    security_groups = [aws_security_group.web.id]
  }

  ingress {
    from_port = 22 #https

    to_port = 22

    protocol = "tcp"

    cidr_blocks = [aws_vpc.my-vpc.cidr_block]


  }

  ingress {
    from_port = -1 #https

    to_port = -1

    protocol = "icmp"

    cidr_blocks = [aws_vpc.my-vpc.cidr_block]
  }



  egress {

    from_port = 80

    to_port = 80

    protocol = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {

    from_port = 443

    to_port = 443

    protocol = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
  }







  tags = {
    Name = "Database MySQL"
  }

}

resource "aws_security_group" "alb" {


  name        = "ALB-SG"
  description = "load Balancer SG"
  vpc_id      = aws_vpc.my-vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "Load Balancer"
  }
}

resource "aws_security_group" "autoscaling" {


  name        = "autoscaling"
  description = "Security group that allows ssh/http and all egress traffic"
  vpc_id      = aws_vpc.my-vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  egress {

    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }

  tags = {
    Name = "Auto Scaling"
  }
}

resource "aws_security_group" "jenkins" {
  name        = "Jenkins"
  description = "Allow incoming connections to Jenkins machine"
  vpc_id      = aws_vpc.my-vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.my-vpc.cidr_block]
  }

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = [aws_vpc.my-vpc.cidr_block]
  }

  egress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.web.id]
  }

  tags = {
    Name = "Jenkins machine"
  }
}