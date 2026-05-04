output "storage_account_name" {
  value = azurerm_storage_account.sa.name
}

output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "container_name" {
  value = azurerm_storage_container.container.name
}

output "container_access_type" {
  value = azurerm_storage_container.container2.name
}