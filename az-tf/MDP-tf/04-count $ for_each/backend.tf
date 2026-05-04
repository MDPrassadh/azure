terraform {
  backend "azurerm" {
    resource_group_name  = "COMMON-RG"
    storage_account_name = "azb50tfstate"   # ✅ exact match
    container_name       = "sgbackend"
    key                  = "prod.tfstate"
  }
}

