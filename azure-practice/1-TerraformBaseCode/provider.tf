terraform {
  required_version = ">= 1.3.9"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
    # aws = {
    #   source  = "hashicorp/aws"
    #   version = "~> 6.0"
    # }
  }
}

provider "azurerm" {
  features {}
}
provider "aws" {
  region = "us-east-1"
}
provider "google" {
  features {}
}
