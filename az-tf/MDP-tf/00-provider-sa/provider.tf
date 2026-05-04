terraform {
  #required_version = ">= 1.3.9"
  required_version = ">= 1.6.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
  
}
provider "azurerm" {
  features {}
}