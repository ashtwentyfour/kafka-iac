# Kafka IaC 

Use this repository to install Apache Kafka and Zookeeper on Google Cloud Platform (GCP) VMs

## 2-Step Process (Step 1 - Provision Cloud Infrastructure):

* Run the Terraform scripts that provision a private network (https://cloud.google.com/vpc/docs/vpc)

* An SSH key pair must be generated prior to executing the Terraform scripts as the path to the public key must be provided

* The number of Kafka nodes can also be modified (usually an odd number) from the default '3'

* Terraform will also deploy 3 Zookeeper VMs and a Bastion Host with connectivity to the public internet via a Cloud NAT to be used as the Ansible control node

* Execute Terraform (plan):

```
terraform plan -var 'gce_ssh_pub_key_file=~/.ssh/ansible_ssh.pub'
```

* Deploy GCP Resources (apply):

```
terraform apply -var 'gce_ssh_pub_key_file=~/.ssh/ansible_ssh.pub'
```

* The value for the ```member_account``` variable must be provided. This is a GCP User(s) or Service Account who/that will be granted permissions to access the Bastion Host

* The output from running ```terraform apply``` will print the inventory with the address of the Kafka and Zookeeper VMs. Save the inventory details. For example: 

```
[kafka]
10.2.0.6 ansible_user=kafka
10.2.0.2 ansible_user=kafka
10.2.0.3 ansible_user=kafka

[zookeeper]
10.2.0.7 ansible_user=zk
10.2.0.5 ansible_user=zk
10.2.0.4 ansible_user=zk
```

## Step 2 - Install Kafka and Zookeeper using Ansible Playbooks

* Login to the Bastion Host:

```
gcloud compute ssh kafka-bastion
```

* Install Ansible and Git:

```
sudo apt update
sudo apt install git
sudo apt install ansible
```

* Create a new 'vault.yml' file with the following template:

```
keys:
    - title: <key-name>
      body: <private-ssh-key>
service_accounts:
    - title: <service-account-email>
      body: <service-account-json-key>
```

* The private SSH key in the vault is the private key generated prior to executing the Terraform scripts
* The service account is an account with permissions access Cloud Storage Buckets
* Encrypt the vault using:

```
ansible-vault encrypt vault.yml
```

* Upload Kafka, Zookeeper and Java packages to a Cloud Storage Bucket. For example:

```
https://storage.cloud.google.com/packages-dd0e0354-05c8-4096-af1c-e7ff15ae3dfe/kafka/kafka_2.13-3.5.1.tgz

https://storage.cloud.google.com/packages-dd0e0354-05c8-4096-af1c-e7ff15ae3dfe/zookeeper/apache-zookeeper-3.9.0-bin.tar.gz

https://storage.cloud.google.com/packages-dd0e0354-05c8-4096-af1c-e7ff15ae3dfe/java/jre-8u381-linux-x64.tar.gz
```

* Run the 'operations.yml' playbook to copy the SSH key out of the vault (create a local 'vault-pass.txt' file with the vault password):

```
ansible-playbook --vault-password-file vault-pass --extra-vars="@vault.yml" operations.yml
```

* Execute the playbook which installs Kafka and Zookeeper:

```
ansible-playbook main.yml --extra-vars="@vault.yml" --vault-password-file vault-pass.txt -i inventory.ini --private-key /tmp/ansible_private_ssh
```
