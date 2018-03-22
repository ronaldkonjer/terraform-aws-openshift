# Define the RHEL 7.4 AMI by:
# RedHat, Latest, x86_64, EBS, HVM, RHEL 7.4
data "aws_ami" "node" {
  most_recent = true

  owners = ["309956199498"] // Red Hat's account ID.

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "name"
    values = ["RHEL-7.4*"]
  }
}

# Define an Amazon Linux AMI.
data "aws_ami" "bastion" {
  most_recent = true

  owners = ["137112412989"]

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "name"
    values = ["amzn-ami-hvm-*"]
  }
}


# data "aws_ami" "bastion" {
#     most_recent = true

#   owners = ["137112412989"]

#   filter {
#     name   = "architecture"
#     values = ["x86_64"]
#   }

#   filter {
#     name   = "root-device-type"
#     values = ["ebs"]
#   }

#   filter {
#     name   = "virtualization-type"
#     values = ["hvm"]
#   }

#   filter {
#     name   = "name"
#     values = ["amzn-ami-hvm-*"]
#   }
# }

# data "aws_ami" "node" {
#     owners      = ["309956199498"]
#     most_recent = true

#     filter {
#         name   = "name"
#         values = ["RHEL-7.4*"]
#     }

#     filter {
#         name   = "architecture"
#         values = ["x86_64"]
#     }

#     filter {
#         name   = "root-device-type"
#         values = ["ebs"]
#     }

#     filter {
#         name   = "virtualization-type"
#         values = ["hvm"]
#     }
# }

