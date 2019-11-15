sudo apt-get install unzip
wget https://releases.hashicorp.com/terraform/0.12.15/terraform_0.12.15_linux_amd64.zip
unzip terraform_0.12.15_linux_amd64.zip
export ARM_CLIENT_ID=$1
export ARM_CLIENT_SECRET=$2
export ARM_SUBSCRIPTION_ID=$3
export ARM_TENANT_ID=$4
terraform init
terraform plan -out plan.out
terraform apply plan.out -auto-approve

export vmss_ip=$(terraform output instance_ip_addr)
echo "host1 ansible_ssh_port=50001 ansible_ssh_host=$vmss_ip" > inventory
echo "host2 ansible_port=50002 ansible_ssh_host=$vmss_ip" >> inventory

cat inventory