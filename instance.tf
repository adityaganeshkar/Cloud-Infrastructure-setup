# Define the EC2 instance in Public Instance
resource "aws_instance" "terraform-server" {
  for_each = local.instance_ami
  ami             = each.value  # Specify the AMI ID for the desired image
  instance_type   = "t2.micro"  # Set your desired instance type
  subnet_id       = aws_subnet.public-subnet.id
  key_name        = "Q-iam-key-us-east2"  # Set the key pair name for SSH access
  security_groups  = [aws_security_group.instance_sg.id]
  user_data = file("${path.module}/shell_scripts/nginx.sh")
  depends_on = [
    aws_vpc.terraform-vpc
  ]

  tags = {
    Name = each.key
  }
}

# Define the private EC2 instance
resource "aws_instance" "private_instance" {
  ami             = "ami-05fb0b8c1424f266b"  # Specify the AMI ID for the private EC2 instance
  instance_type   = "t2.micro"  # Set your desired instance type
  subnet_id       = aws_subnet.private-subnet.id
  key_name        = "Q-iam-key-us-east2"  # Set the key pair name for SSH access (if needed)
  security_groups  = [aws_security_group.instance_sg.id]
  
  depends_on = [
    aws_vpc.terraform-vpc
  ]

  tags = {
    Name = "private-ec2-instance"
  }
}