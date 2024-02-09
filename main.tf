# Define provider (AWS in this case)
provider "aws" {
  region = "us-east-1"  # Update with your preferred region
}

# Create a new VPC
resource "aws_vpc" "terraform-vpc" {
  cidr_block = "10.0.0.0/16"  # Update with your preferred CIDR block
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "terraform-vpc"
  }
}

# Create a public-subnet in the VPC
resource "aws_subnet" "public-subnet" {
  vpc_id                  = aws_vpc.terraform-vpc.id
  cidr_block              = "10.0.1.0/24"  # Update with your preferred CIDR block for the subnet
  availability_zone       = "us-east-1a"   # Update with your preferred availability zone
  map_public_ip_on_launch = true
  tags = {
    Name = "public-subnet"
  }
}

# Create a private-subnet in the VPC
resource "aws_subnet" "private-subnet" {
  vpc_id                  = aws_vpc.terraform-vpc.id
  cidr_block              = "10.0.2.0/24"  # Update with your preferred CIDR block for the subnet
  availability_zone       = "us-east-1a"   # Update with your preferred availability zone
  map_public_ip_on_launch = true
  tags = {
    Name = "private-subnet"
  }
}


# Create an internet gateway for the VPC
resource "aws_internet_gateway" "my_igw" {
  tags = {
    Name = "my-igw"
  }
}

# Attach the internet gateway to the VPC
resource "aws_internet_gateway_attachment" "igt-Attach" {
  internet_gateway_id = aws_internet_gateway.my_igw.id
  vpc_id              = aws_vpc.terraform-vpc.id
}

# Create a route table for the subnet
resource "aws_route_table" "my_route_table" {
  vpc_id = aws_vpc.terraform-vpc.id
  tags = {
    Name = "my-route-table"
  }
}

# Create a route in the route table to route traffic to the internet through the internet gateway
resource "aws_route" "my_route" {
  route_table_id         = aws_route_table.my_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.my_igw.id
}

# Associate the route table with the subnet
resource "aws_route_table_association" "my_route_table_association" {
  subnet_id      = aws_subnet.public-subnet.id
  route_table_id = aws_route_table.my_route_table.id
}

# Define a security group for the EC2 instance
resource "aws_security_group" "instance_sg" {
  name        = "instance-sg"
  description = "Security group for EC2 instance"

  vpc_id = aws_vpc.terraform-vpc.id

  # Define ingress rules as needed
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow SSH from anywhere (for demonstration purposes)
  }

  # Add additional ingress rules as needed
}

# Define the EC2 instance in Public Instance
resource "aws_instance" "terraform-server" {
  ami             = "ami-0c7217cdde317cfec"  # Specify the AMI ID for the desired image
  instance_type   = "t2.micro"  # Set your desired instance type
  subnet_id       = aws_subnet.public-subnet.id
  key_name        = "root-key"  # Set the key pair name for SSH access
  security_groups  = [aws_security_group.instance_sg.id]

  tags = {
    Name = "Terraform-Server"
  }
}

# Define the private EC2 instance
resource "aws_instance" "private_instance" {
  ami             = "ami-0c7217cdde317cfec"  # Specify the AMI ID for the private EC2 instance
  instance_type   = "t2.micro"  # Set your desired instance type
  subnet_id       = aws_subnet.private-subnet.id
  key_name        = "root-key"  # Set the key pair name for SSH access (if needed)
  security_groups  = [aws_security_group.instance_sg.id]

  tags = {
    Name = "private-ec2-instance"
  }
}