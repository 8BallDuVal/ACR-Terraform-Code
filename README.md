# create an ACR in Terraform
Terraform script(s) to deploy an azure container registry (ACR) 

# Prerequisites
Software Required:
- Azure CLI (az CLI): https://docs.microsoft.com/en-us/cli/azure/install-azure-cli
- Terraform: https://www.terraform.io/downloads 

Create the following resources in Azure to store the terraform state file in an azure storage account:
- resource group
- storage account
- storage container
- private endpoint for storage account

For more info about storing the terraform state file remotely, see [this page](https://docs.microsoft.com/en-us/azure/developer/terraform/store-state-in-azure-storage?tabs=azure-cli).

# On the command line before running this terraform script:
```
az login
az account show                                     # verify you are in correct subscription
az account set --subscription <subscription-name>   # to set az cli to correct subscription if necessary
terraform init
terraform plan
terraform apply
```

# Following tutorial to login and push/pull docker images from ACR: 
https://docs.microsoft.com/en-us/azure/container-registry/container-registry-get-started-docker-cli?tabs=azure-cli

Commands used to test ACR functionality:
```
#### Set variables. ####
# If using Linux/Bash, use this syntax.
ACR_NAME="testACRduval"     # If using Linux/Bash, use this syntax.
SUBSCRIPTION_NAME="test-subscription-duval"

# If using Powershell, use this syntax.
#$ACR_NAME="testACRduval"    
#$SUBSCRIPTION_NAME="test-subscription-duval"

# Log in to az cli in the correct subscription
az login
az account set --subscription $SUBSCRIPTION_NAME   # to set az cli to correct subscription if necessary

# log in to ACR
az acr login --name $ACR_NAME

# Example of pushing an image to your ACR instance
docker pull mcr.microsoft.com/oss/nginx/nginx:1.15.5-alpine
docker tag mcr.microsoft.com/oss/nginx/nginx:1.15.5-alpine $ACR_NAME.azurecr.io/samples/nginx 
docker push $ACR_NAME.azurecr.io/samples/nginx

# Example of pulling an image from your ACR instance
docker pull $ACR_NAME.azurecr.io/samples/nginx
```
