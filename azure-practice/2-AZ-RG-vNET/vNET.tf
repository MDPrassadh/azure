resource "azurerm_virtual_network" "vNET" {
  name                = "${azurerm_resource_group.HUB_RG.name}-vNET"
  location            = azurerm_resource_group.HUB_RG.location
  resource_group_name = azurerm_resource_group.HUB_RG.name # implicit dependency on 
  #resource group creation which is named in rg.tf file as "HUB_RG"
  address_space = ["10.1.0.0/16"]


  tags = {
    environment = "Development"
    managedBy   = "Terraform"
    owner       = "Azure-prassadh"
  }
}
resource "azurerm_subnet" "vNET-subnet-1" {
  name                 = "${azurerm_virtual_network.vNET.name}-subnet1"
  resource_group_name  = azurerm_resource_group.HUB_RG.name # implicit dependency on resource group creation which is named in rg.tf file as "HUB_RG"
  virtual_network_name = azurerm_virtual_network.vNET.name  # implicit dependency on vNET creation which is named in this file as "vNET"   
  address_prefixes     = ["10.1.1.0/24"]

}

resource "azurerm_subnet" "vNET-subnet-2" {
  name                 = "${azurerm_virtual_network.vNET.name}-subnet2"
  resource_group_name  = azurerm_resource_group.HUB_RG.name # implicit dependency on resource group creation which is named in rg.tf file as "HUB_RG"
  virtual_network_name = azurerm_virtual_network.vNET.name  # implicit dependency on vNET creation which is named in this file as "vNET"   
  address_prefixes     = ["10.1.2.0/24"]
}

resource "azurerm_subnet" "vNET-subnet-3" {
  name                 = "${azurerm_virtual_network.vNET.name}-subnet3"
  resource_group_name  = azurerm_resource_group.HUB_RG.name # implicit dependency on resource group creation which is named in rg.tf file as "HUB_RG"
  virtual_network_name = azurerm_virtual_network.vNET.name  # implicit dependency on vNET creation which is named in this file as "vNET"   
  address_prefixes     = ["10.1.3.0/24"]

}
  