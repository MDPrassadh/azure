resource "azurerm_resource_group" "practice-tf" {
  name     = "prassadh-rg"
  location = "EASTUS"


  tags = {
    environment = local.commom_tags.environment
    project     = local.commom_tags.project
    lob         = local.commom_tags.lob
    stage       = local.commom_tags.stage

  }
}
 
# terraform plan -var=environment=prod   # for string variable
# terraform plan -var='tags={environment="prod"}' # for map variable
output "resource_group_name" {
  value = azurerm_resource_group.practice-tf.name
  
}

output "resource_group_details" {
  value = {
    name = azurerm_resource_group.practice-tf.name
    id = azurerm_resource_group.practice-tf.id
    location = azurerm_resource_group.practice-tf.location
  }
}