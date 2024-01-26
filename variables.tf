variable "resource_group_name"{
  type = string
  description = "name of the resource group terraform will create to store the ACR instance"
}

variable "geolocation"{
  type = string
  default = "eastus"
  description = "geolocation of resources you want to create. defaults to eastus"
}

variable "subnet_name"{
  type = string
  description = "name of the subnet (should already exist)"
}

variable "vnet_name"{
  type = string
  description = "name of the vnet (should already exist)"
}

variable "vnet_rg"{
  type = string
  description = "name of the vnet resource group (should already exist)"
}

variable "storage_account_name"{
  type = string
  description = "name of the tfstate storage account you want to create"
}

variable "acr_name"{
  type = string
  description = "name of the ACR you want to create"
}

variable "acr_pe_name"{
  type = string
  description = "name of the private endpoint you want to create for the ACR"
}
