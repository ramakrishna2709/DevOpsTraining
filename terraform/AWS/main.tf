>>>>>>>>>>>>>>>>>>>>>.deploy a single server >>>>>>>>>>>>>>>>>>>

provider "aws" {
 region = "eu-west-1"
 version = "~> 1.19"
 access_key = "${var.aws_access_key}"
 secret_key = "${var.aws_secret_key}"
}

resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  tags = {
    Name = "terraform-example"
  }
}


>>>>>>>>>>>....bootup script to install apache >>>>>>>>>

resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World" > index.html
              nohup busybox httpd -f -p 8080 &
              EOF
  tags = {
    Name = "terraform-example"
  }
}


>>>>>>>>>>>>>>>>>>>>.security group>>>>>>>>>>>>>>>>>>>>>.

By default, AWS does not allow any incoming or outgoing traffic from an EC2 Instance. 
To allow the EC2 Instance to receive traffic on port 8080, you need to create a security group:

resource "aws_security_group" "instance" {
  name = "terraform-example-instance"
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}



>>>>>>>>>>>>>>>>>.. add reference and adding SG to ec2 instance >>>>>>>>>.....

EC2 Instance to actually use it by passing the ID of the security group into the vpc_security_group_ids argument of the aws_instance resource.

<PROVIDER>_<TYPE>.<NAME>.<ATTRIBUTE>
ex: aws_security_group.instance.id


resource "aws_instance" "example" {
  ami                    = "ami-0c55b159cbfafe1f0"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.instance.id]
  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World" > index.html
              nohup busybox httpd -f -p 8080 &
              EOF
  tags = {
    Name = "terraform-example"
  }
}



>>>>>>>>>>>>>>>>>>>>>>>>>>>>Deploy a Configurable Web Server >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

code follows DRY priniciple 
 Don’t Repeat Yourself (DRY) principle: every piece of knowledge must have a single, unambiguous, 
 authoritative representation within a system.
 
 >>>>>>>>.Port will be repeated -----
 Terraform allows you to define input variables
 
 
 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
 resource "aws_security_group" "instance" {
  name = "terraform-example-instance"
  ingress {
    from_port   = var.server_port
    to_port     = var.server_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}



>>>>>>>>>>>>>>>>>>>>>
user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World" > index.html
              nohup busybox httpd -f -p "${var.server_port}" &
              EOF
			  



>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>Deploy a cluster of web servers>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>.

Auto Scaling Group (ASG)>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>.

>>>>>>>>>>>..creating an ASG is to create a launch configuration, which specifies how to configure each EC2 Instance in the A


resource "aws_launch_configuration" "example" {
  image_id        = "ami-0c55b159cbfafe1f0"
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.instance.id]
  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World" > index.html
              nohup busybox httpd -f -p "${var.server_port}" &
              EOF
  lifecycle {
    create_before_destroy = true
  }
}



ASG >>>>>>>>>>>>>>>>>>>>>>>>.


resource "aws_autoscaling_group" "example" {
  launch_configuration = aws_launch_configuration.example.id
  min_size = 2
  max_size = 10
  tag {
    key                 = "Name"
    value               = "terraform-asg-example"
    propagate_at_launch = true
  }
}

To make this ASG work, you need to specify one more parameter: availability_zones


\>>>>>>>>>>>>>>>>>>>>>>>>ASG final >>>>>>>>>>>>>>

resource "aws_autoscaling_group" "example" {
  launch_configuration = aws_launch_configuration.example.id
  availability_zones   = data.aws_availability_zones.all.names
  min_size = 2
  max_size = 10
  tag {
    key                 = "Name"
    value               = "terraform-asg-example"
    propagate_at_launch = true
  }
}



>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>Deploy a load balancer

create a CLB using the aws_elb resource:


resource "aws_elb" "example" {
  name               = "terraform-asg-example"
  availability_zones = data.aws_availability_zones.all.names
}
 
 
 >>>>>>>>>>>>>>>>>>>.elb with listner>>>>>>>>>>>>>>>>
 
 resource "aws_elb" "example" {
  name               = "terraform-asg-example"
  availability_zones = data.aws_availability_zones.all.names
  # This adds a listener for incoming HTTP requests.
  listener {
    lb_port           = 80
    lb_protocol       = "http"
    instance_port     = var.server_port
    instance_protocol = "http"
  }
}



>>>>>>>>>>>>>>>>....elb with securtiy group


resource "aws_security_group" "elb" {
  name = "terraform-example-elb"
  # Allow all outbound
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # Inbound HTTP from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


>>>>>>>>>>>>>>>>>>>>>>>>>>>...final elb>>>>>>>>>>>>>>>>>>>>>>>>>>
resource "aws_elb" "example" {
  name               = "terraform-asg-example"
  security_groups    = [aws_security_group.elb.id]
  availability_zones = data.aws_availability_zones.all.names
  # This adds a listener for incoming HTTP requests.
  listener {
    lb_port           = var.elb_port
    lb_protocol       = "http"
    instance_port     = var.server_port
    instance_protocol = "http"
  }
}



>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>alb with health check for ec2 instances >>>>>>>>>>>>>>>>>>>>>>>>


resource "aws_elb" "example" {
  name               = "terraform-asg-example"
  security_groups    = [aws_security_group.elb.id]
  availability_zones = data.aws_availability_zones.all.names
  health_check {
    target              = "HTTP:${var.server_port}/"
    interval            = 30
    timeout             = 3
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
  # This adds a listener for incoming HTTP requests.
  listener {
    lb_port           = var.elb_port
    lb_protocol       = "http"
    instance_port     = var.server_port
    instance_protocol = "http"
  }
}




>>>>>>>>>>>>>..................ASG with Dynamic Load balancers instance group


resource "aws_autoscaling_group" "example" {
  launch_configuration = aws_launch_configuration.example.id
  availability_zones   = data.aws_availability_zones.all.names
  min_size = 2
  max_size = 10
  load_balancers    = [aws_elb.example.name]
  health_check_type = "ELB"
  tag {
    key                 = "Name"
    value               = "terraform-asg-example"
    propagate_at_launch = true
  }
}