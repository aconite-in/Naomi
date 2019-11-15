sudo apt-get install unzip
wget https://releases.hashicorp.com/terraform/0.12.7/terraform_0.12.7_linux_amd64.zip
unzip terraform_0.12.15_linux_amd64.zip
sudo mv terraform /usr/local/bin/
cd $(System.DefaultWorkingDirectory)/_Naomi-CI/drop
terraform init
terraform plan -out plan.out