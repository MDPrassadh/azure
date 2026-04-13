terraform {
  #required_version = ">= 1.3.9"
  required_version = ">= 1.14.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "COMMON-RG"
    storage_account_name = "azb50devtfstate"
    container_name       = "tfstate"
    key                  = "dev-terraform.tfstate"

  }
}
provider "azurerm" {
  features {}
}