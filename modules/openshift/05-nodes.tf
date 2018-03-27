//  Create an SSH keypair
resource "aws_key_pair" "keypair" {
  key_name   = "${var.key_name}"
  public_key = "${file(var.public_key_path)}"
}

//  Create the master userdata script.
data "template_file" "setup-master" {
  template = "${file("${path.module}/files/setup-master.sh")}"
  vars {
    availability_zone = "${lookup(var.subnetaz, var.region)}"
  }
}

//  Launch configuration for the consul cluster auto-scaling group.
resource "aws_instance" "master" {
  ami                  = "${data.aws_ami.node.id}"
  # Master nodes require at least 16GB of memory.
  instance_type        = "m4.xlarge"
  subnet_id            = "${aws_subnet.public-subnet.id}"
  iam_instance_profile = "${aws_iam_instance_profile.openshift-instance-profile.id}"
  user_data            = "${data.template_file.setup-master.rendered}"
  private_ip           = "172.24.28.83"

  vpc_security_group_ids = [
    "${aws_security_group.openshift-vpc.id}",
    "${aws_security_group.openshift-public-ingress.id}",
    "${aws_security_group.openshift-public-egress.id}",
  ]

  //  We need at least 30GB for OpenShift, let's be greedy...
  root_block_device {
    volume_size = 50
    volume_type = "gp2"
  }

  # Storage for Docker, see:
  # https://docs.openshift.org/latest/install_config/install/host_preparation.html#configuring-docker-storage
  ebs_block_device {
    device_name = "/dev/sdf"
    volume_size = 80
    volume_type = "gp2"
  }

  ebs_block_device {
    device_name = "/dev/xvdbk"
    volume_size = 1
    volume_type = "gp2"
  }

  ebs_block_device {
    device_name = "/dev/xvdbm"
    volume_size = 1
    volume_type = "gp2"
  }

  key_name = "${aws_key_pair.keypair.key_name}"

  ### Need the file on the bastion server
  # setup connection using the jumphost
  # connection {
  #   agent = false
  #   bastion_host = "${aws_instance.bastion.private_ip}"
  #   bastion_user = "${var.aws_instance_user}"
  #   bastion_port = 22
  #   bastion_private_key = "${file("${var.private_key_path}")}"
  #   user = "${var.aws_instance_user}"
  #   private_key = "${file("${var.private_key_path}")}"
  #   host = "${self.private_ip}"
  #   timeout = "2m"
  # }

  # # create local for it => https://www.terraform.io/docs/configuration/locals.html
  # # create file on the server
  # provisioner "file" {
  #   source      = "./modules/openshift/files/cg-dnsmasq.cfg"
  #   destination = "/cg-dnsmasq.cfg"
  # }

  # # move file to etc/dnsmasq.d/
  # provisioner "remote-exec" {
  #   inline = [
  #     "sudo mv /cg-dnsmasq.cfg /etc/dnsmasq.d/",
  #     "chmod 755 /etc/dnsmasq.d/cg-dnsmasq.cfg"
  #   ]
  # }

  tags = "${map(
    "kubernetes.io/cluster/${var.platform_name}", "owned",
    "Name", "OpenShift Master",
    "Project", "openshift"
  )}"
}

//  Create the node userdata script.
data "template_file" "setup-node" {
  template = "${file("${path.module}/files/setup-node.sh")}"
  vars {
    availability_zone = "${lookup(var.subnetaz, var.region)}"
  }
}

//  Create the two nodes. This would be better as a Launch Configuration and
//  autoscaling group, but I'm keeping it simple...
resource "aws_instance" "node1" {
  ami                  = "${data.aws_ami.node.id}"
  instance_type        = "${var.amisize}"
  subnet_id            = "${aws_subnet.public-subnet.id}"
  iam_instance_profile = "${aws_iam_instance_profile.openshift-instance-profile.id}"
  user_data            = "${data.template_file.setup-node.rendered}"
  private_ip           = "172.24.28.250"

  vpc_security_group_ids = [
    "${aws_security_group.openshift-vpc.id}",
    "${aws_security_group.openshift-public-ingress.id}",
    "${aws_security_group.openshift-public-egress.id}",
  ]

  //  We need at least 30GB for OpenShift, let's be greedy...
  root_block_device {
    volume_size = 50
    volume_type = "gp2"
  }

  # Storage for Docker, see:
  # https://docs.openshift.org/latest/install_config/install/host_preparation.html#configuring-docker-storage
  ebs_block_device {
    device_name = "/dev/sdf"
    volume_size = 80
    volume_type = "gp2"
  }

  ebs_block_device {
    device_name = "/dev/xvdbe"
    volume_size = 1
    volume_type = "gp2"
  }

  key_name = "${aws_key_pair.keypair.key_name}"

 
  tags = "${map(
    "kubernetes.io/cluster/${var.platform_name}", "owned",
    "Name", "OpenShift Node 1",
    "Project", "openshift"
  )}"
}
resource "aws_instance" "node2" {
  ami                  = "${data.aws_ami.node.id}"
  instance_type        = "${var.amisize}"
  subnet_id            = "${aws_subnet.public-subnet.id}"
  iam_instance_profile = "${aws_iam_instance_profile.openshift-instance-profile.id}"
  user_data            = "${data.template_file.setup-node.rendered}"
  private_ip           = "172.24.28.201"

  vpc_security_group_ids = [
    "${aws_security_group.openshift-vpc.id}",
    "${aws_security_group.openshift-public-ingress.id}",
    "${aws_security_group.openshift-public-egress.id}",
  ]

  //  We need at least 30GB for OpenShift, let's be greedy...
  root_block_device {
    volume_size = 50
    volume_type = "gp2"
  }

  # Storage for Docker, see:
  # https://docs.openshift.org/latest/install_config/install/host_preparation.html#configuring-docker-storage
  ebs_block_device {
    device_name = "/dev/sdf"
    volume_size = 80
    volume_type = "gp2"
  }

  ebs_block_device {
    device_name = "/dev/xvdbv"
    volume_size = 1
    volume_type = "gp2"
  }

   ebs_block_device {
    device_name = "/dev/xvdcg"
    volume_size = 1
    volume_type = "gp2"
  }

  key_name = "${aws_key_pair.keypair.key_name}"

  tags = "${map(
    "kubernetes.io/cluster/${var.platform_name}", "owned",
    "Name", "OpenShift Node 2",
    "Project", "openshift"
  )}"
}
