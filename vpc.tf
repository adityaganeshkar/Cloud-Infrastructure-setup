# Create a new VPC
resource "aws_vpc" "terraform-vpc" {
  cidr_block           = "10.0.0.0/16" # Update with your preferred CIDR block
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "terraform-vpc"
  }
}

# Create a public-subnet in the VPC
resource "aws_subnet" "public-subnet" {
  vpc_id                  = aws_vpc.terraform-vpc.id
  cidr_block              = var.vpc_settings["public_subnet"] # Update with your preferred CIDR block for the subnet
  availability_zone       = var.vpc_settings["public_az"]     # Update with your preferred availability zone
  map_public_ip_on_launch = true
  tags = {
    Name = "public-subnet"
  }
}

# Create a private-subnet in the VPC
resource "aws_subnet" "private-subnet" {
  vpc_id                  = aws_vpc.terraform-vpc.id
  cidr_block              = var.vpc_settings["private_subnet"] # Update with your preferred CIDR block for the subnet
  availability_zone       = var.vpc_settings["private_az"]     # Update with your preferred availability zone
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

# Creating Elastic IP
resource "aws_eip" "elastic-ip" {
  depends_on = [aws_internet_gateway.my_igw]

}

# Create the NAT gateway
resource "aws_nat_gateway" "NAT-gateway" {
  allocation_id = aws_eip.elastic-ip.id
  subnet_id     = aws_subnet.public-subnet.id

  tags = {
    Name = "Terraform NAT"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_eip.elastic-ip]
}

# Create a route table for the subnet
resource "aws_route_table" "my_route_table" {
  vpc_id = aws_vpc.terraform-vpc.id
  tags = {
    Name = "my-route-table"
  }
}

# Create a route in the route table to connect to internet through the internet gateway
resource "aws_route" "public-route" {
  route_table_id         = aws_route_table.my_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.my_igw.id
}

# Associate the route table with the subnet
resource "aws_route_table_association" "public-subnet-association" {
  subnet_id      = aws_subnet.public-subnet.id
  route_table_id = aws_route_table.my_route_table.id
}

# Create a route table for the subnet
resource "aws_route_table" "pri" {
  vpc_id = aws_vpc.terraform-vpc.id
  tags = {
    Name = "my-pri-table"
  }
}

# Create a route for private-subnet
resource "aws_route" "private-route" {
  route_table_id         = aws_route_table.pri.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.NAT-gateway.id
}


# Associate the route table with the subnet
resource "aws_route_table_association" "private-subnet-association" {
  subnet_id      = aws_subnet.private-subnet.id
  route_table_id = aws_route_table.pri.id
}