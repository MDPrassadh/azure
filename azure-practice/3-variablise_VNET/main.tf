resource "azurerm_resource_group" "hub_rg" {
  name     = var.hub_rg_name
  location = var.location

  tags = {
    environment = "Production"
    managedBy   = "Terraform"
    owner       = "Azure-prassadh"
  }
}

resource "azurerm_virtual_network" "vNET" {
  name                = "${var.hub_rg_name}-vNET"
  location            = var.location
  resource_group_name = azurerm_resource_group.hub_rg.name # implicit dependency on 
  #resource group creation which is named in rg.tf file as "HUB_RG"
  address_space = var.vNET_cidr_block
}

resource "azurerm_subnet" "subnet1" {
  name                 = "subnet1"
  resource_group_name  = azurerm_resource_group.hub_rg.name
  virtual_network_name = azurerm_virtual_network.vNET.name
  address_prefixes     = var.vNET_subnet1_cidr_block
}

resource "azurerm_subnet" "subnet2" {
  name                 = "subnet2"
  resource_group_name  = azurerm_resource_group.hub_rg.name
  virtual_network_name = azurerm_virtual_network.vNET.name
  address_prefixes     = var.vNET_subnet2_cidr_block
}

resource "azurerm_subnet" "subnet3" {
  name                 = "subnet3"
  resource_group_name  = azurerm_resource_group.hub_rg.name
  virtual_network_name = azurerm_virtual_network.vNET.name
  address_prefixes     = var.vNET_subnet3_cidr_block
}
