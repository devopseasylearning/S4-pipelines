resource "aws_lb_target_group" "example" {
    name     = "example-tg"
    port     = 3000
    protocol = "HTTP"
    vpc_id   = aws_vpc.main_vpc.id # specify the VPC ID
  
    health_check {
      enabled             = true
      interval            = 30
      path                = "/"
      port                = "traffic-port"
      timeout             = 3
      healthy_threshold   = 3
      unhealthy_threshold = 3
      matcher             = "200-399"
    }

    tags = {
        Name        = local.Name
        Project     = local.Project
        Application = local.Application
        Environment = local.Environment
        Owner       = local.Owner
      }
  }

  
  resource "aws_lb_target_group_attachment" "example" {
    target_group_arn = aws_lb_target_group.example.arn
    target_id        = aws_instance.example.id
    port             = 3000

  }

  
  resource "aws_lb" "example" {
    name               = "example-alb"
    internal           = false
    load_balancer_type = "application"
    security_groups    = [aws_security_group.allow_all.id] # Security Group for ALB
    subnets            = [aws_subnet.public_subnet.id]  # Specify your public subnet
  
    enable_deletion_protection = false
  
    enable_cross_zone_load_balancing   = true

    tags = {
        Name        = local.Name
        Project     = local.Project
        Application = local.Application
        Environment = local.Environment
        Owner       = local.Owner
      }
  }
  



  resource "aws_lb_listener" "example" {
    load_balancer_arn = aws_lb.example.arn
    port              = 80
    protocol          = "HTTP"
  
    default_action {
      type             = "forward"
      target_group_arn = aws_lb_target_group.example.arn
    }
    tags = {
        Name        = local.Name
        Project     = local.Project
        Application = local.Application
        Environment = local.Environment
        Owner       = local.Owner
      }
  }
  
output "load_balancer_dns_name" {
  description = "The DNS name of the load balancer."
  value       = aws_lb.example.dns_name
}
