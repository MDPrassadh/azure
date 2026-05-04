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
    resource_group_name  = "MDP-RG"
    storage_account_name = "prassadhsa"
    container_name       = "az-statefile-backup"
    key                  = "az-prod.tf.tfstate"

  }
}
provider "azurerm" {
  features {}
}




 