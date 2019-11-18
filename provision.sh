sudo apt-get install unzip
wget https://releases.hashicorp.com/terraform/0.11.14/terraform_0.11.14_linux_amd64.zip
unzip terraform_0.11.14_linux_amd64.zip
export ARM_CLIENT_ID=$1
export ARM_CLIENT_SECRET=$2
export ARM_SUBSCRIPTION_ID=$3
export ARM_TENANT_ID=$4
terraform init
terraform plan -out plan.out
terraform apply -auto-approve

export vmss_ip=$(terraform output instance_ip_addr)
echo "host1 ansible_ssh_port=22 ansible_ssh_host=$vmss_ip" > inventory

cat inventory