# String type variable with default value and description
variable "environment" {
  type    = string
  default = "staging"
  description = "related to environment"
}

# Number type variable with default value and description
variable "instance_count" {
  type    = number
  default = 2
  description = "number of instances to create"
}
# Boolean type variable with default value and description
variable "enable_monitoring" {  
  type    = bool
  default = true
  description = "enable monitoring for the instances"
}
variable "storage_disk" {
    type    = number
    default = 80
    description = "size of the storage disk in GB"
}
variable "delete_os_disk_on_termination_vm" {
    type    = bool
    default = true
    description = "whether to delete the OS disk when the VM is deleted"
} 
variable "delete_public_ip_on_termination" {
    type    = bool
    default = true
    description = "whether to delete the public IP when the VM is deleted"
}

# variables.tf
variable "vm_sizes" {
  type    = list(string)
  default = ["Standard_B2s", "Standard_B1s", "Standard_D2s_v3", ]
}

variable "location_allowed" {
  type    = list(string) # List type variable example... a list of allowed locations for the resources or a list of locations to choose from when creating resources.or an array of strings that can be used to specify the location of resources in Azure.
  default = [ "westus", "eastus", "centralus", "southcentralus", "westus" ]   # Default value is set to "westus", but it can be modified to include other locations as needed.
}

variable "address_spaces" {
  type    = list(string)
  default = ["10.0.0.0/16", "10.1.0.0/16", "10.2.0.0/16"]
}

variable "resource_tags" {
  type    = map(string)
  default = {
    "environment" = "staging"
    "owner"       = "devops-team"
    "project"     = "azure-infrastructure"
    "description" = "tags for the resources"
  }
}
# tuple type 
variable "network_configurations" {
  type = tuple([ string, string, number ])  # Tuple type variable example... a tuple of three strings representing different network configurations such as subnet names or address prefixes.
  description = "network configuration tuple: [subnet_name, address_prefix, security_group_name] Vnet address space, subnet address prefix, and network security group name." 
  default = [ "10.0.0.0/16", "10.0.2.0/24", 0 ]
}
variable "allowed_ports" {
  type    = set(number)
  default = [22, 80, 443, 22]  # duplicate 22 removed
}

# object type variable example... an object representing the configuration of a virtual machine, including properties such as the VM size, OS type, and storage configuration.
variable "vm_configuration" {
  type = object({
    vm_size          = string
    os_type          = string
    storage_account  = string
    delete_os_disk_on_termination = bool
  })
  default = {
    vm_size          = "Standard_B2s"
    os_type          = "Linux"
    storage_account  = "Standard_LRS"
    delete_os_disk_on_termination = true
  }
}



# variable "vm_size" {
#   type    = string
#   default = "Standard_B2s"

#   validation {
#     condition     = contains(["Standard_B2s", "Standard_B1s","Standard_D2s_v3", ], var.vm_size)
#     error_message = "VM size must be one of Standard_B2s, Standard_D2s_v3, or Standard_B1s."
#   }
# }


