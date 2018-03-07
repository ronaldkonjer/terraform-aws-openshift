//  Setup the core provider information.
provider "aws" {
  region  = "${var.region}"
  profile = "cg-iac"
}

//  Create the OpenShift cluster using our module.
module "openshift" {
  source          = "./modules/openshift"
  region          = "${var.region}"
  amisize         = "t2.large"    //  Smallest that meets the min specs for OS
  vpc_cidr        = "172.24.0.0/16"
  subnetaz        = "${var.subnetaz}"
  subnet_cidr     = "172.24.28.0/24"
  key_name        = "openshift"
  public_key_path = "${var.public_key_path}"
}

//  Output some useful variables for quick SSH access etc.
output "master-url" {
  value = "https://${module.openshift.master-public_ip}.xip.io:8443"
}
output "master-public_dns" {
  value = "${module.openshift.master-public_dns}"
}
output "master-public_ip" {
  value = "${module.openshift.master-public_ip}"
}
output "bastion-public_dns" {
  value = "${module.openshift.bastion-public_dns}"
}
output "bastion-public_ip" {
  value = "${module.openshift.bastion-public_ip}"
}
output "splunk-private_ip" {
  value = "${module.openshift.splunk-private_ip}"
}
output "splunk-console-url" {
  value = "http://${module.openshift.splunk-public_dns}:8000"
}
