variable "allowed_locations" {
  type    = list(string)
  default = ["eastus", "westus", "centralus"]
  description = "List of allowed locations for resource deployment."
}

# variable "storage_account_name" {
#   type    = string
#   default = "azb51devtfstate"
#   description = "Name of the existing storage account to be used for state management."
# }
# for multiple storage accounts we can use list of string instead of single string like for instance 
# using list of string we can create multiple storage accounts by providing multiple names in the default value like for instance   

variable "storage_account_name" {
  #type    = list(string) # This defines the variable as a list of strings,
                          # allowing us to provide multiple storage account names. 
                          # for_each and count can be used to create multiple resources based on the number of items in this list.
                          # Difference between for_each and count is that for_each allows us to create resources based on a map or set of strings, 
                          # while count creates resources based on a simple integer count.
                          # in this case we are using count to create resources based on the number of items in the list.
                          # for_each doesnt work with list of string      it works with map or set of string but count works with list of string as well as map or set of string. 
  type         = set(string)   
  default      = ["azb51devtfstate2", "azb51devtfstate3", "azb51devtfstate4"]
  description  = "Name of the existing storage account to be used for state management."

}
