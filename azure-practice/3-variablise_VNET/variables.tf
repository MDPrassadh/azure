variable "hub_rg_name" {
  description = "The name of the hub resource group."
  type        = string

}

variable "location" {
  description = "The Azure region where resources will be created."
  type        = string

}
variable "owner" {
  description = "The owner of the resources."
  type        = string

}
variable "environment" {
  description = "The environment for the resources."
  type        = string

}
variable "managed_by" {
  description = "The entity that manages the resources."
  type        = string

}
variable "vNET_cidr_block" {
  description = "The address space for the vNET."
  type        = list(string)

}

variable "vNET_subnet1_cidr_block" {
  description = "The address prefixes for the vNET subnets."
  type        = list(string)

}
variable "vNET_subnet2_cidr_block" {
  description = "The address prefixes for the vNET subnets."
  type        = list(string)

}
variable "vNET_subnet3_cidr_block" {
  description = "The address prefixes for the vNET subnets."
  type        = list(string)

}

