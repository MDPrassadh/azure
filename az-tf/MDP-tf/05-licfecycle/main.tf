# RG CREATION and Create beofre destroy policy for this with rg and storage account creation and backend configuration for this lifecycle policy.
resource "azurerm_resource_group" "rg" {
  name     = "RG-MDPRASADH"
  location = var.allowed_locations[0]
  lifecycle {
    prevent_destroy = true
  } # This will prevent the resource group from being destroyed. If we try to destroy the resource group, it will throw an error and it will not allow us to destroy the resource group. This is a safety measure to prevent accidental deletion of resources. We can also use this policy for other resources like storage account, virtual network, etc. We can also use this policy for all resources in the resource group by using the lifecycle block in the resource group and then we can use the create_before_destroy policy for all resources in the resource group. This will ensure that when we make changes to the resources in the resource group, it will create new resources before destroying the old resources. This will ensure that there is no downtime for the resources in the resource group.
#   lifecycle {
#     create_before_destroy = true # 
#   }
   # We can also use variable for location and then we can use the variable in the resource block. Here we are using the first element of the allowed_locations list as the location for the resource group. We can also use other elements of the list or we can use a random element from the list by using the random function.
}

resource "azurerm_storage_account" "sa" {
  name                     = "prassadhmdpsa"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  lifecycle {
    prevent_destroy = true
  }

#   lifecycle {
#     create_before_destroy = true # 
#   }

  tags = {
    environment = "staging"
  }
}
# container creation based on earlier created rg and sa 
resource "azurerm_storage_container" "container" {
  name                  = "prassadhcontainer"
  storage_account_id    = azurerm_storage_account.sa.id
  container_access_type = "private"
  lifecycle {
    prevent_destroy = true
  }
#   lifecycle {
#     create_before_destroy = true
#   }
}

resource "azurerm_storage_container" "container2" {
  name                  = "prassadhcontainer3"
  storage_account_id    = data.azurerm_storage_account.sa.id
  container_access_type = "private"
  lifecycle {
    prevent_destroy = true
  }
#   lifecycle {
#     create_before_destroy = true
#   }
}



