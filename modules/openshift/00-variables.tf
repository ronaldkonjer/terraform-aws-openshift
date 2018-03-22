variable "region" {
  description = "The region to deploy the cluster in, e.g: eu-west-1."
}

variable "amisize" {
  description = "The size of the cluster nodes, e.g: t2.large. Note that OpenShift will not run on anything smaller than t2.large"
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC, e.g: 10.0.0.0/16"
}

variable "subnetaz" {
  description = "The AZ for the public subnet, e.g: eu-west-1a"
  type = "map"
}

variable "subnet_cidr" {
  description = "The CIDR block for the public subnet, e.g: 10.0.1.0/24"
}

variable "key_name" {
  description = "The name of the key to user for ssh access, e.g: consul-cluster"
}

variable "public_key_path" {
  description = "The local public key path, e.g. ~/.ssh/id_rsa.pub"
}

variable "aws_vpc_cg-aws_id" {
  default = "vpc-4fac482b"
  description = "The vpc id of the already existing VPC that is not in Terraform state"
}

variable "aws_route_table_public_id" {
  default = "rtb-0b30646f"
  description = "The route table id of the already existing route that is connected to the VPN"
}

variable "platform_name" {
  default = "Openshift"
}

variable "aws_instance_user" {
  default = "ec2-user"
}

variable "private_key_path" {
  default = "~/.ssh/awscgkey"
}