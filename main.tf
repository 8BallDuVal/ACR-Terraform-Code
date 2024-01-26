# set up terraform and provider blocks
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.95.0"
    }
  }
  backend "azurerm" {
    # terraform does not allow the use of variables here, so they must be hardcoded.
    # resource group, storage account, and container in the storage account must have already been created in azure portal.
    # storage account also needs a private endpoint configured in the portal
    resource_group_name = "acr-tfstate-rg"
    storage_account_name = "tfstateacr"
    container_name = "terraform-state"
    key = "tfstate"
  }
}

# required features block, not sure why it is required.
provider "azurerm" {
  features {}
}

# resource group in a desired geolocation. Must have already been created in azure portal
resource "azurerm_resource_group" "acr-rg" {
  name     = var.resource_group_name
  location = var.geolocation
}

# get subnet information
data "azurerm_subnet" "subnet" {
  name                                      = var.subnet_name
  virtual_network_name                      = var.vnet_name
  resource_group_name                       = var.vnet_rg
}

# get vnet information
data "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  resource_group_name = var.vnet_rg
}

# create an Azure Container Registry (ACR)
resource "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = azurerm_resource_group.acr-rg.name
  location            = azurerm_resource_group.acr-rg.location
  sku                 = "Premium"
  admin_enabled       = false
  public_network_access_enabled = false
  identity {
    type = "SystemAssigned"
  }
}

# create the azure container registry (ACR) private endpoint
resource "azurerm_private_endpoint" "acr-pe" {
  name                = var.acr_pe_name
  location            = var.geolocation
  resource_group_name = azurerm_resource_group.acr-rg.name
  subnet_id           = data.azurerm_subnet.subnet.id

  private_service_connection {
    name                           = "privateserviceconnection"
    private_connection_resource_id = azurerm_container_registry.acr.id
    is_manual_connection           = false
    subresource_names              = [ "registry" ]
  }
}