set -x

# Elevate priviledges, retaining the environment.
sudo -E su

# curl "https://bootstrap.pypa.io/get-pip.py" -o "get-pip.py" # python get-pip.py

# install epel-release for yum
#yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm

yum install -y "@Development Tools" python2-pip openssl-devel python-devel gcc libffi-devel httpd-tools
pip install -Iv ansible==2.4.3.0 
pip install passlib 

# install telnet
# yum install telnet telnet-server -y

# Remove the openshift-ansible dir if exists
if [ -d ./openshift-ansible ]; then rm -rf ./openshift-ansible; fi

# Clone the openshift-ansible repo, which contains the installer.
if [ ! -d ./openshift-ansible ]; then
	git clone -b release-3.9 https://github.com/openshift/openshift-ansible;
fi

# Run the playbook.
#ANSIBLE_HOST_KEY_CHECKING=False /usr/local/bin/ansible-playbook -i ./inventory.cfg -f 2 ./openshift-ansible/playbooks/byo/config.yml -vvv # uncomment for verbose! -vvv

#sudo rm -f /etc/yum.repos.d/CentOS-OpenShift-Origin.repo
#ANSIBLE_HOST_KEY_CHECKING=False /usr/local/bin/ansible-playbook -i ./inventory.cfg ./openshift-ansible/playbooks/byo/openshift-cluster/upgrades/v3_7/upgrade.yml -vvv # uncomment for verbose! -vvv


#ANSIBLE_HOST_KEY_CHECKING=False /usr/local/bin/ansible-playbook -i ./inventory.cfg ./openshift-ansible/playbooks/adhoc/uninstall.yml -vvv # uncomment for verbose! -vvv


ANSIBLE_HOST_KEY_CHECKING=False /usr/local/bin/ansible-playbook -i ./inventory.cfg -f 2 ./openshift-ansible/playbooks/prerequisites.yml -vvv # uncomment for verbose! -vvv
ANSIBLE_HOST_KEY_CHECKING=False /usr/local/bin/ansible-playbook -i ./inventory.cfg ./openshift-ansible/playbooks/deploy_cluster.yml -vvv # uncomment for verbose! -vvv
# If needed, uninstall with the below:
# ansible-playbook playbooks/adhoc/uninstall.yml
