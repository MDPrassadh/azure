

# output "storage_account_details" {
#   value = {
#     name = azurerm_storage_account.DP1[count.index].name
#   }
# }

# output "storage_account_details" {
#   value = {
#     name = azurerm_storage_account.DP1[*].name # This uses a splat expression to get the name of all storage accounts created with count. The [*] syntax tells Terraform to return a list of the name attribute for all instances of the azurerm_storage_account.DP1 resource.
#     # location = azurerm_storage_account.DP1[*].location # We can also get other properties of the storage account like location, account tier, replication type etc by using the same approach.  
#   }
# }

# Durga, the error is because count.index cannot be used inside an output block. 
# The count object only exists inside resources, modules,
#  or data blocks where count is explicitly set. Outputs don’t have that context.


# 1. Use a splat expression ([*])
# If you want all storage accounts created with count:

# output "storage_account_names" {
#   value = azurerm_storage_account.DP1[*].name
# }

# output "storage_account_locations" {
#   value = azurerm_storage_account.DP1[*].location
# }


# for Structured sense we can use with for loop also to get output in key value pair format like for instance

# For list of strings output with for loop to get key value pair format

# output "storage_account_details" {
#   value = { for i in range(length(azurerm_storage_account.DP)) : i.
#     azurerm_storage_account.DP[i].name => azurerm_storage_account.DP[i].location }
#   description = "A map of storage account names to their locations."
# } 

 # Here  We use set or map of strings to create resources with for_each and then we can use for loop in output to get the output in key value pair format where key is the name of the storage account and value is the location of the storage account.  
# output "storage_account_details" {
#   value = {
#     for k, sa in azurerm_storage_account.DP :  # here we are iterating over the resources created with for_each and getting the key and value of each resource. 
#       sa.name => sa.location # here we are using the name of the storage account as the key and location of the storage account as the value in the output. 
#       # sa.name => sa.account_tier # we can also get other properties of the storage account like account tier, replication type etc by using the same approach. 
      # sa.name => sa.account_replication_type
      # sa.name => sa.resource_group_name
      # sa.name => sa.tags
      # sa.name => sa.id
      # sa.name => sa.primary_blob_endpoint
      # sa.name => sa.primary_queue_endpoint
      # sa.name => sa.primary_table_endpoint
      # sa.name => sa.primary_file_endpoint
      # sa.name => sa.primary_web_endpoint
      # sa.name => sa.primary_location
      # sa.name => sa.secondary_location 
    
#   }
#   description = "A map of storage account names to their locations."
# }

# For list of strings output with for loop to get key value pair format with for_each locations also displayed in output
output "storage_account_names" {
  value = [for sa in azurerm_storage_account.DP : sa.name ] # This uses a for expression to iterate over all instances of the azurerm_storage_account.DP resource and creates a list of their names. The result will be a list of storage account names created with for_each.
  description = "A list of storage account names."
}