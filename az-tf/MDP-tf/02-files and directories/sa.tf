# esource "azurerm_storage_account" "practice-tf" {
#   name                     = "mdpsa"
#   resource_group_name      = azurerm_resource_group.practice-tf.name
#   location                 = azurerm_resource_group.practice-tf.location
#   account_tier             = "Standard"
#   account_replication_type = "GRS"

#   tags = {
#     environment = local.commom_tags.environment
#     project     = local.commom_tags.project
#   }
# }r

# # container creation 
# resource "azurerm_storage_container" "practice-tf" {
#   name                  = "tfstate"
#   storage_account_id    = azurerm_storage_account.practice-tf.id
#   container_access_type = "private"
# }

# Reference existing Resource Group
# data "azurerm_resource_group" "common" {
#   name = "COMMON-RG"
# }

# # Create Storage Account inside COMMON-RG
# resource "azurerm_storage_account" "practice" {
#   name                     = "piyushbackend123"   # must be unique, lowercase, 3–24 chars
#   resource_group_name      = data.azurerm_resource_group.common.name
#   location                 = data.azurerm_resource_group.common.location
#   account_tier             = "Standard"
#   account_replication_type = "LRS"
# }

# Create Blob Container inside that Storage Account
# resource "azurerm_storage_container" "practice" {
#   name                  = "tfstatebackend"
#   storage_account_id    = azurerm_storage_account.practice.id
#   container_access_type = "private"
# }

# Reference existing Resource Group
data "azurerm_resource_group" "common" {
  name = "COMMON-RG"
}

# Reference existing Storage Account
data "azurerm_storage_account" "existing_sa" {
  name                = "azb50devtfstate"   # your existing SA name
  resource_group_name = data.azurerm_resource_group.common.name
}

# Create Blob Container inside existing Storage Account
resource "azurerm_storage_container" "tfstate" {
  name                  = "prassadhbackend"   # container name (lowercase, simple)
  storage_account_id    = data.azurerm_storage_account.existing_sa.id
  container_access_type = "private"
}
