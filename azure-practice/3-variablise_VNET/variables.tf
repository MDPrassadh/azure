variable "hub_rg_name" {
  description = "The name of the hub resource group."
  type        = string
  default     = "AZB50-HUB-RG"
}

variable "location" {
  description = "The Azure region where resources will be created."
  type        = string
  default     = "East US"
}
variable "owner" {
  description = "The owner of the resources."
  type        = string
  default     = "Azure-prassadh"
}
variable "environment" {
  description = "The environment for the resources."
  type        = string
  default     = "Development"
}
variable "managed_by" {
  description = "The entity that manages the resources."
  type        = string
  default     = "Terraform"
}
variable "vNET_cidr_block" {
  description = "The address space for the vNET."
  type        = list(string)
  default     = ["10.1.0.0/16"]
}

variable "vNET_subnet1_cidr_block" {
  description = "The address prefixes for the vNET subnets."
  type        = list(string)
  default     = ["10.1.1.0/24"]
}
variable "vNET_subnet2_cidr_block" {
  description = "The address prefixes for the vNET subnets."
  type        = list(string)
  default     = ["10.1.2.0/24"]
}
variable "vNET_subnet3_cidr_block" {
  description = "The address prefixes for the vNET subnets."
  type        = list(string)
  default     = ["10.1.3.0/24"]
}

