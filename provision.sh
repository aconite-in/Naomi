sudo apt-get install unzip
sudo apt-get install sshpass
wget https://releases.hashicorp.com/terraform/0.11.14/terraform_0.11.14_linux_amd64.zip
unzip terraform_0.11.14_linux_amd64.zip

export ARM_CLIENT_ID=$1
export ARM_CLIENT_SECRET=$2
export ARM_SUBSCRIPTION_ID=$3
export ARM_TENANT_ID=$4
terraform init
terraform plan -out plan.out
terraform apply -auto-approve plan.out

export vmss_ip=$(terraform output instance_ip_addr)
echo "host1 ansible_ssh_port=22 ansible_ssh_host=$vmss_ip" > inventory
echo "[all:vars]" >> inventory
echo "ansible_connection=ssh" >> inventory
echo "ansible_user=testadmin" >> inventory
echo "ansible_ssh_pass=Password1234!" >> inventory

cat inventory
export ANSIBLE_HOST_KEY_CHECKING=False


sudo sshpass -p "Password1234!" scp -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -r ../../_aconite-in.Sonic/drop/Sonic testadmin@$vmss_ip:~/