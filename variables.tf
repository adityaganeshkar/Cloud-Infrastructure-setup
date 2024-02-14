# variables.tf
locals {
  instance_ami= {"Instance-1":"ami-05fb0b8c1424f266b","Instance-2":"ami-05fb0b8c1424f266b"}
}

# Instance Type modification
variable "instance_type" {
  default = "t2.micro"
  
}

# Instance key
variable "instance_key"{
  default = "Q-iam-key-us-east2"
} 