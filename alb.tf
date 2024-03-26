resource "aws_lb" "this" {

  name = "Terraform0-ALB"

  security_groups = [aws_security_group.alb.id]

  subnets = [aws_subnet.this["pub_a"].id, aws_subnet.this["pub_b"].id]

  tags = {
    Name = "Terraform ALB"
  }

}

resource "aws_lb_target_group" "this" {

  name     = "ALB-TG"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.my-vpc.id

  health_check {

    path = "/"

    healthy_threshold = 2

  }

}

resource "aws_lb_listener" "this" {

  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward" #encaminha a requisição para o target_group
    target_group_arn = aws_lb_target_group.this.arn

  }

}