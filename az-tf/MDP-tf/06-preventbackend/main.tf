# RG Existing details thrpguh data source

# -------------------------
# Storage Account (backend state) existing sa account is prassadhmdpsa using this details to create the storage account with same name and same details. This will prevent the backend state from being deleted when we run terraform destroy command. This is a safety measure to prevent accidental deletion of resources. We can also use this policy for other resources like virtual network, etc. We can also use this policy for all resources in the resource group by using the lifecycle block in the resource group and then we can use the create_before_destroy policy for all resources in the resource group. This will ensure that when we make changes to the resources in the resource group, it will create new resources before destroying the old resources. This will ensure that there is no downtime for the resources in the resource group.   
# -------------------------


resource "azurerm_storage_container" "tfstate" {
  name                  = "tfstate"
  storage_account_name  = azurerm_storage_account.mdprassadh.id
  container_access_type = "private"
}



