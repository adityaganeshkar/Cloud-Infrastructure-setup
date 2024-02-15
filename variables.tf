# variables.tf
locals {
  instance_ami= {"Instance-1":"ami-05fb0b8c1424f266b","Instance-2":"ami-05fb0b8c1424f266b"}
}

# Instance Parameters Setting
variable "instance_settings" {
  description = "Settings for the EC2 instance"
  type        = map(string)

  default = {
   # ami           = "ami-xxxxxxxxxxxxxxxxx",  # Replace with your desired default AMI ID
    instance_type = "t2.micro",               # Replace with your desired default instance type
    ec2_key = "Q-iam-key-us-east2"
  }
}

# Subnets Parameters Setting
variable "vpc_settings" {
  description = "Settings of the subnets ranges"
  type        = map(any)

  default = {
    public_subnet  = "10.0.1.0/24",
    public_az = "us-east-2a",
    private_subnet = "10.0.2.0/24",
    private_az = "us-east-2a",

  }
}
