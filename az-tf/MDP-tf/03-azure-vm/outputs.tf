output "resource_group_details" {
  value = {
    name     = azurerm_resource_group.example.name
    location = azurerm_resource_group.example.location
  }
  description = "Details of the created resource group, including its name and location."
  }

  # Here also we can get all the values of the resource group using * like for instance
# output "resource_group_details" {
#   value = azurerm_resource_group.example.*  # This will return a list of all the attributes of the resource group, including its name and location.
#   description = "Details of the created resource group, including its name and location." 
#}

output "virtual_machine_details" {
  value = { 
    name     = azurerm_virtual_machine.main.name
    location = azurerm_virtual_machine.main.location
    vm_size  = azurerm_virtual_machine.main.vm_size
  }
  description = "Details of the created virtual machine, including its name, location, and size."
}
# Instead of all virtual machine details .name .location .vm_size we can use only single line to get all those three values in
# using *  like for instance
# output "virtual_machine_details" {
#   value = azurerm_virtual_machine.main.*  # This will return a list of all the attributes of the virtual machine resource, including its name, location, and size.
#   description = "Details of the created virtual machine, including its name, location, and size."
# }


output "network_interface_details" {
  value = {
    name     = azurerm_network_interface.main.name
    location = azurerm_network_interface.main.location
  }
  description = "Details of the created network interface, including its name and location."
}
output "virtual_network_details" {
  value = {
    name          = azurerm_virtual_network.main.name
    address_space  = azurerm_virtual_network.main.address_space
    location       = azurerm_virtual_network.main.location
  }
  description = "Details of the created virtual network, including its name, address space, and location."
}
output "subnet_details" {
  value = {
    name             = azurerm_subnet.internal.name
    address_prefixes = azurerm_subnet.internal.address_prefixes
    location         = azurerm_virtual_network.main.location
  }
  description = "Details of the created subnet, including its name, address prefixes, and location."
}

  
# instead of all subnet details .name .address_prefaction .location we can use only single line to get all those three values in
# using *  like for instance

 # output "subnet_details" {
#   value = azurerm_subnet.internal.*  # This will return a list of all the attributes of the subnet resource, including its name, address prefixes, and location.
#   description = "Details of the created subnet, including its name, address prefixes, and location."
# }
