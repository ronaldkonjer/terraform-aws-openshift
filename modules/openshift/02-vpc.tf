//  Define the VPC.
resource "aws_vpc" "cg-aws" {
  cidr_block           = "${var.vpc_cidr}"
  enable_dns_hostnames = true
  enable_dns_support   = true
  instance_tenancy     = "default"

  tags {
    Name = "cg-aws-openshift"
    Project = "openshift"
  }
}

//  Create an Internet Gateway for the VPC.
resource "aws_internet_gateway" "openshift" {
  vpc_id = "${aws_vpc.cg-aws.id}"

  tags {
    Name    = "OpenShift IGW"
    Project = "openshift"
  }
}

//  Create a public subnet.
resource "aws_subnet" "public-subnet" {
  vpc_id                  = "${aws_vpc.cg-aws.id}"
  cidr_block              = "${var.subnet_cidr}"
  availability_zone       = "${lookup(var.subnetaz, var.region)}"
  map_public_ip_on_launch = true
  depends_on              = ["aws_internet_gateway.openshift"]

  tags {
    Name    = "OpenShift Public Subnet"
    Project = "openshift"
  }
}

//  Create a route table allowing all addresses access to the IGW.
resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.cg-aws.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.openshift.id}"
  }

  tags {
    Name    = "OpenShift Public Route Table"
    Project = "openshift"
  }
}

//  Now associate the route table with the public subnet - giving
//  all public subnet instances access to the internet.
resource "aws_route_table_association" "public-subnet" {
  subnet_id      = "${aws_subnet.public-subnet.id}"
  route_table_id = "${aws_route_table.public.id}"
}
