sudo apt-get install unzip
wget https://releases.hashicorp.com/terraform/0.12.15/terraform_0.12.15_linux_amd64.zip
unzip terraform_0.12.15_linux_amd64.zip
az login --identity -u /subscriptions/$1/resourcegroups/myRG/providers/Microsoft.ManagedIdentity/userAssignedIdentities/myID
terraform init
terraform plan -out plan.out