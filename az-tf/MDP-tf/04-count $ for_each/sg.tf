# Reference existing Resource Group
data "azurerm_resource_group" "DP" {
    name = "COMMON-RG"
    }

resource "azurerm_storage_account" "DP" {
  #count                   = length(var.storage_account_name) # != "" ? 1 : 0 # This condition checks if the storage account name at the current index is not an empty string. If it's not empty, it creates one instance of the storage account; otherwise, it creates zero instances.
  #name                    = var.storage_account_name[count.index] # This sets the name of the storage account to the value at the current index of the storage_account_name variable.
  
  for_each                = var.storage_account_name  # != 0 ? toset(var.storage_account_name) : [] # This condition checks if the length of the storage_account_name list is not zero. If it's not zero, it converts the list to a set and iterates over it to create resources for each unique name. If the list is empty, it results in an empty set, and no resources are created.
  name                    = each.key # This sets the name of the storage account to the value corresponding to the current key in the storage_account_name variable. Each key corresponds to an index in the list, allowing us to create multiple storage accounts based on the number of names provided in the list.
  resource_group_name     = data.azurerm_resource_group.DP.name
  location                = var.allowed_locations[1]
  account_tier            = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = "staging"
  }
}

