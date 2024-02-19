# Define a security group for the EC2 instance
resource "aws_security_group" "instance_sg" {
  name        = "instance-sg"
  description = "Security group for EC2 instance"

  vpc_id = aws_vpc.terraform-vpc.id

  dynamic "ingress" {
    for_each = [22, 80, 443, 3306]
    iterator = port
    content {
      from_port   = port.value
      to_port     = port.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"] # Allow SSH from anywhere (for demonstration purposes)
    }
  }



  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # Allow all outbound traffic
    cidr_blocks = ["0.0.0.0/0"]
  }


}