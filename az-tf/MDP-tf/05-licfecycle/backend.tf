terraform {
    backend "azurerm" {
    resource_group_name  = "COMMON-RG"
    storage_account_name = "azb50devtfstate"
    container_name       = "tf-life-cycle"
    key                  = "prassadhbackend.tfstate"
   }
}
