resource "azurerm_resource_group" "hub_rg" {
  name     = "AZB50-HUB-RG"
  location = "East US"

  tags = {
    environment = "Production"
    managedBy   = "Terraform"
    owner      = "Azure-prassadh"
  }
}

resource "azurerm_resource_group" "sp1_rg" {
  name     = "AZB50-SP1-RG"
  location = "East US"

  tags = {
    environment = "Production"     
    managedBy   = "Terraform"
    owner      = "Azure-prassadh"
  }
}

resource "azurerm_resource_group" "sp2_rg" {
  name     = "AZB50-SP2-RG"
  location = "West US"

  tags = {
    environment = "Production"
    managedBy   = "Terraform"
    owner      = "Azure-prassadh"
  }
}

# resource "azurerm_resource_group" "HUB_RG-1" {
#   name     = "AZB50-HUB-RG-1"
#   location = "East US"

#   tags = {
#     environment = "Production"
#     managedBy   = "Terraform"
#   }
# }

# resource "azurerm_resource_group" "SP1_RG-1" {
#   name     = "AZB50-SP1-RG-1"
#   location = "East US"

#   tags = {
#     environment = "Production"
#     managedBy   = "Terraform"
#   }
# }

# resource "azurerm_resource_group" "SP2_RG-1" {
#   name     = "AZB50-SP2-RG-1"
#   location = "West US"

#   tags = {
#     environment = "Production"
#     managedBy   = "Terraform"
#   }
# }

# output "hub_rg_id" {
#   value = azurerm_resource_group.HUB_RG.id
# }

# output "sp1_rg_id" {
#   value = azurerm_resource_group.SP1_RG.id
# }

# output "sp2_rg_id" {
#   value = azurerm_resource_group.SP2_RG.id
# }

# output "hub_rg_1_id" {
#   value = azurerm_resource_group.HUB_RG-1.id
# }

# output "sp1_rg_1_id" {
#   value = azurerm_resource_group.SP1_RG-1.id
# }

# output "sp2_rg_1_id" {
#   value = azurerm_resource_group.SP2_RG-1.id
# }



