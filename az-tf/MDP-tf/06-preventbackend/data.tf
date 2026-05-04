

data "azurerm_storage_account" "mdprassadh" {
  name                = azurerm_storage_account.sa.name
  resource_group_name = azurerm_resource_group.rg.name
}
data "azurerm_resource_group" "mdprassadh" {
  name = azurerm_resource_group.rg.name
}
