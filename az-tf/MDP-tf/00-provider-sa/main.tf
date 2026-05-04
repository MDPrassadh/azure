
resource "azurerm_storage_account" "practice-tf" {
  name                     = "prassadhsa"
  resource_group_name      = azurerm_resource_group.practice-tf.name
  location                 = azurerm_resource_group.practice-tf.location
  account_tier             = "Standard"
  account_replication_type = "GRS"

  tags = {
    environment = "staging"
  }
}

# container creation 
resource "azurerm_storage_container" "practice-tf" {
  name                  = "az-statefile-backup"
  storage_account_name  = azurerm_storage_account.practice-tf.id
  container_access_type = "private"
}