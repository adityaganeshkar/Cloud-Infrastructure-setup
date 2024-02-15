# variables.tf
locals {
  instance_ami= {"-1":"ami-0c20d88b0021158c6","Instance-2":"ami-0c20d88b0021158c6"}
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
