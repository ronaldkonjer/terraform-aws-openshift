set -x

# Elevate priviledges, retaining the environment.
sudo -E su

# curl "https://bootstrap.pypa.io/get-pip.py" -o "get-pip.py" # python get-pip.py

# install epel-release for yum
#yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm

yum install -y "@Development Tools" python2-pip openssl-devel python-devel gcc libffi-devel
pip install -Iv ansible==2.4.2.0 

# install telnet
#yum install telnet telnet-server -y

# Remove the openshift-ansible dir if exists
if [ -d ./openshift-ansible ]; then rm -Rf ./openshift-ansible; fi

# Clone the openshift-ansible repo, which contains the installer.
git clone -b release-3.6 https://github.com/openshift/openshift-ansible

# Run the playbook.
ANSIBLE_HOST_KEY_CHECKING=False /usr/local/bin/ansible-playbook -i ./inventory.cfg ./openshift-ansible/playbooks/byo/config.yml -vvv # uncomment for verbose! -vvv
#ANSIBLE_HOST_KEY_CHECKING=False /usr/local/bin/ansible-playbook -i ./inventory.cfg ./openshift-ansible/playbooks/deploy_cluster.yml -vvv # uncomment for verbose! -vvv
# If needed, uninstall with the below:
# ansible-playbook playbooks/adhoc/uninstall.yml
