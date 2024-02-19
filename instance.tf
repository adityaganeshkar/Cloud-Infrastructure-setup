# Define the EC2 instance in Public Instance
resource "aws_instance" "terraform-server" {
  for_each        = local.instance_ami
  ami             = each.value                             # Specify the AMI ID for the desired image
  instance_type   = var.instance_settings["instance_type"] # Set your desired instance type
  subnet_id       = aws_subnet.public-subnet.id
  key_name        = var.instance_settings["ec2_key"] # Set the key pair name for SSH access
  security_groups = [aws_security_group.instance_sg.id]
  user_data       = file("${path.module}/shell_scripts/nginx.sh")

  depends_on = [
    aws_vpc.terraform-vpc
  ]

  tags = {
    Name = each.key
  }
}

# Define the private EC2 instance
resource "aws_instance" "private_instance" {
  ami             = "ami-0c20d88b0021158c6"                # Specify the AMI ID for the private EC2 instance
  instance_type   = var.instance_settings["instance_type"] # Set your desired instance type
  subnet_id       = aws_subnet.private-subnet.id
  key_name        = var.instance_settings["ec2_key"] # Set the key pair name for SSH access (if needed)
  security_groups = [aws_security_group.instance_sg.id]
  user_data       = file("${path.module}/shell_scripts/Database.sh")

  depends_on = [
    aws_vpc.terraform-vpc
  ]

  tags = {
    Name = "private-ec2-instance"
  }
}