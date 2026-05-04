
# Here we can witnessed the use of different types of variables in Terraform, including string, number, and boolean types. 
# The variables are defined in the `variables.tf` file and are used in the `vm.tf` file to create Azure resources such as a resource group, virtual network, subnet, network interface, and virtual machine. The variables allow for flexibility and reusability of the Terraform code by enabling users to customize values without modifying the code directly.
# Those are primitive variables
#Non primitive variables are more complex data structures that can hold multiple values, such as lists, maps, tuples , set and objects. They allow for more advanced configurations and can be used to create more complex infrastructure setups. Examples of non-primitive variables include lists of strings, maps of key-value pairs, and objects that contain multiple attributes. These variables can be defined in the `variables.tf` file and used in the `vm.tf` file to create resources with more complex configurations.


# String type variable with default value and description

resource "azurerm_resource_group" "example" {
  name     = "${var.environment}-resources"  # String type variable example...
  location = var.location_allowed[1]  # List type variable example... using the second element of the list (index 1) for the location
  #location = var.location_allowed[length(var.location_allowed) - 1] # List type variable example... using the last element of the list for the location
  #location = var.location_allowed[floor(length(var.location_allowed) / 2)] # List type variable example... using the middle element of the list for the location
  # # Last element (-1 equivalent)
   #var.location_allowed[length(var.location_allowed) - 1]  # List type variable example... using the last element of the list for the location No positive index for the last element in Terraform, so we use length of the list minus one to access it.

  # Second last element (-2 equivalent)
   #var.location_allowed[length(var.location_allowed) - 2] # List type variable example... using the second last element of the list for the location No positive index for the second last element in Terraform, so we use length of the list minus two to access it.

}

# String type variable with default value and description
resource "azurerm_virtual_network" "main" {
  name                = "${var.environment}-network"
  address_space       = [element(var.address_spaces, 0)]  # List type variable example... using the first element of the list (index 0) for the address space
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}

# String type variable with default value and description
resource "azurerm_subnet" "internal" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.main.name
  #address_prefixes = [var.network_configurations[1], var.network_configurations[2]]
  address_prefixes = ["${var.network_configurations[1]}", "${var.network_configurations[2]}"]  # Tuple type variable example... using the first and second elements of the tuple for the address prefixes

}

resource "azurerm_network_interface" "main" {
  name                = "${var.environment}-nic"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.main.id   # ✔ now valid
  }
}


resource "azurerm_public_ip" "main" {
  name                = "${var.environment}-pip"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  allocation_method   = "Static"
  sku                 = "Standard"
}


resource "azurerm_virtual_machine" "main" {
  name                  = "${var.environment}-vm"
  location              = azurerm_resource_group.example.location
  resource_group_name   = azurerm_resource_group.example.name
  network_interface_ids = [azurerm_network_interface.main.id]
  vm_size               = var.vm_sizes[2]  # List type variable example... using the third element of the list (index 2) for the VM size    

  # Uncomment this line to delete the OS disk automatically when deleting the VM
delete_os_disk_on_termination = var.delete_os_disk_on_termination_vm # Boolean type variable example...

  # Uncomment this line to delete the data disks automatically when deleting the VM
delete_data_disks_on_termination = var.delete_os_disk_on_termination_vm # Boolean type variable example...
# delete public ip when deleting the VM
#delete_public_ip_on_termination = var.delete_public_ip_on_termination  # Boolean type variable example...

  storage_image_reference {
    publisher = var.vm_configuration.publisher   # Object type variable example... using the publisher property of the vm_configuration object
    offer     = var.vm_configuration.offer     # Object type variable example... using the offer property of the vm_configuration object
    sku       = var.vm_configuration.sku       # Object type variable example... using the sku property of the vm_configuration object
    version   = var.vm_configuration.version   # Object type variable example... using the version property of the vm_configuration object
  }
  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
    disk_size_gb       = var.storage_disk  # Number type variable example...
  }
  os_profile {
    computer_name  = "hostname"
    admin_username = "testadmin"
    admin_password = "Password1234!"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  # Using map type variable for tags
  tags = {
    environment = var.resource_tags["environment"]  # Map type variable example... using the "environment" key from the resource_tags map
    owner       = var.resource_tags["owner"]        # Map type variable example... using the "owner" key from the resource_tags map
    project     = var.resource_tags["project"]      # Map type variable example... using the "project" key from the resource_tags map
    description = var.resource_tags["description"]  # Map type variable example... using the "description" key from the resource_tags map
  }
}

# Example of using a set type variable for allowed ports in a network security group rule
resource "azurerm_network_security_group" "example" {
  name                = "${var.environment}-nsg"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  security_rule {
    name                       = "allow-ssh"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges    = tolist(var.allowed_ports) # convert set → list
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}
