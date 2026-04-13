  Everything from main website documentaion............

🔹 Real‑time best practice order
Resource Group (RG) → foundation for all resources.

Virtual Network (VNet) → defines the network boundary.

Subnet(s) → logical segments inside the VNet.

Network Security Group (NSG) → firewall rules for NICs/Subnets.

Public IP (if needed) → explicitly create with unique names.

Network Interface (NIC) → attach NIC to Subnet, NSG, and Public IP.

Virtual Machine (VM) → finally attach the NIC to the VM.

RG=Resource Group Everything will be created in this RG, so we can easily delete it when we are done with the lab.
RG='AZB50-RG'
az group create -l eastus -n ${RG}

# Create two virtual networks in different regions. We will use these virtual networks to create a VNet peering later in the lab.

# Before creating the virtual networks, we will check if the IP address range we want to use is available. This is important because if the IP address range is already in use, we will not be able to create the virtual network.
#az network vnet check-ip-address -g ${RG} -n PvNET-1 --ip-address 10.50.0.0
#az network vnet check-ip-address -g ${RG} -n PvNET-2 --ip-address 192.168.0.0
 
Now we can create the virtual networks. We will use the following command to create the virtual networks:

az network vnet create -g ${RG} -n ${RG}-PvNET-1 --address-prefix 10.50.0.0/16 --subnet-name ${RG}-Subnet-1 --subnet-prefixes 10.50.1.0/24 -l eastus 

az network vnet create -g ${RG} -n ${RG}-PvNET-2 --address-prefix 192.168.0.0/16 --subnet-name ${RG}-Subnet-1 --subnet-prefixes 192.168.1.0/24 -l westus

# now we can create nsg and associate it with the subnet. We will use the following command to create the NSG and associate it with the subnet: 

az network nsg create -g ${RG} -n ${RG}-EAST-NSG-1 -l eastus
az network nsg create -g ${RG} -n ${RG}-WEST-NSG-2 -l westus 

# Now NSG rules will be created in the NSG. We will use the following command to create the NSG rules: allow all traffic from any source to any destination on port 22 (SSH) for both NSGs.
az network nsg rule create -g ${RG} --nsg-name ${RG}-EAST-NSG-1 -n AllowAll-Traffic --priority 100 --access Allow --protocol '*' --direction Inbound --source-address-prefixes '*' --source-port-ranges '*' --destination-address-prefixes '*' --destination-port-ranges '*'  
az network nsg rule create -g ${RG} --nsg-name ${RG}-WEST-NSG-2 -n AllowAll-Traffic --priority 100 --access Allow --protocol '*' --direction Inbound --source-address-prefixes '*' --source-port-ranges '*' --destination-address-prefixes '*' --destination-port-ranges '*'  

# Network Interface Creation: We will create a network interface for each VM. We will use the following command to create the network interfaces:
az network nic create -g ${RG} -n ${RG}-EAST-NIC-1 --vnet-name ${RG}-PvNET-1 --subnet ${RG}-Subnet-1 --network-security-group ${RG}-EAST-NSG-1 -l eastus
az network nic create -g ${RG} -n ${RG}-WEST-NIC-2 --vnet-name ${RG}-PvNET-2 --subnet ${RG}-Subnet-1 --network-security-group ${RG}-WEST-NSG-2 -l westus

# Now we Network Interface (NIC) → attach NIC to Subnet, NSG, and Public IP. We will use the following command to attach the NIC to the subnet, NSG, and public IP: 







# Create VM in both virtual networks. We will use the following command to create the VMs:

IMAGE='Canonical:0001-com-ubuntu-server-jammy:22_04-lts:latest'
# Standard_D2s_v3 is a good size for this lab, but you can choose a different size if you want.
# Just make sure to choose a size that is available in the region you are creating the VM in.

echo "Creating Virtual Machines"
az vm create --resource-group ${RG} --name EAST-LNXSVR1 --image $IMAGE --vnet-name ${RG}-PvNET-1 \
    --subnet ${RG}-Subnet-1 --admin-username azure --admin-password "India@123456" --size Standard_D2s_v3 \
    --nsg ${RG}-EAST-NSG-1 --storage-sku StandardSSD_LRS --os-disk-delete-option Delete --nic-delete-option Delete -l eastus
    
echo "Creating Virtual Machines"
az vm create --resource-group ${RG} --name WEST-LNXSVR2 --image $IMAGE --vnet-name ${RG}-PvNET-2 \
    --subnet ${RG}-Subnet-1 --admin-username azure --admin-password "India@123456" --size Standard_D2s_v3 \
    --nsg ${RG}-WEST-NSG-2 --storage-sku StandardSSD_LRS --os-disk-delete-option Delete --nic-delete-option Delete -l westus

==================================================SCRIPTING FOT ABOVE RG NSG VNET SUBNET NIC AND VM CREATION==================================================

SCRIPT for creating the resource group, virtual networks, NSGs, NICs, and VMs in the lab. This script can be used as a reference for creating resources in Azure using the Azure CLI.

🔹 Real‑time best practice order
Resource Group (RG) → foundation for all resources.

Virtual Network (VNet) → defines the network boundary.

Subnet(s) → logical segments inside the VNet.

Network Security Group (NSG) → firewall rules for NICs/Subnets.

Public IP (if needed) → explicitly create with unique names.

Network Interface (NIC) → attach NIC to Subnet, NSG, and Public IP.

Virtual Machine (VM) → finally attach the NIC to the VM.

# Resource Group
RG='AZB50-RG'
az group create -l eastus -n ${RG}

# Virtual Networks + Subnets
az network vnet create -g ${RG} -n ${RG}-PvNET-1 --address-prefix 10.50.0.0/16 \
    --subnet-name ${RG}-Subnet-1 --subnet-prefixes 10.50.1.0/24 -l eastus 

az network vnet create -g ${RG} -n ${RG}-PvNET-2 --address-prefix 192.168.0.0/16 \
    --subnet-name ${RG}-Subnet-1 --subnet-prefixes 192.168.1.0/24 -l westus

# NSGs
az network nsg create -g ${RG} -n ${RG}-EAST-NSG-1 -l eastus
az network nsg create -g ${RG} -n ${RG}-WEST-NSG-2 -l westus 

# NSG Rules (SSH open for lab)
az network nsg rule create -g ${RG} --nsg-name ${RG}-EAST-NSG-1 -n AllowSSH \
    --priority 100 --access Allow --protocol Tcp --direction Inbound \
    --source-address-prefixes '*' --source-port-ranges '*' \
    --destination-address-prefixes '*' --destination-port-ranges 22

az network nsg rule create -g ${RG} --nsg-name ${RG}-WEST-NSG-2 -n AllowSSH \
    --priority 100 --access Allow --protocol Tcp --direction Inbound \
    --source-address-prefixes '*' --source-port-ranges '*' \
    --destination-address-prefixes '*' --destination-port-ranges 22

# Public IPs
az network public-ip create -g ${RG} -n EAST-LNXSVR1-PIP -l eastus --sku Standard
az network public-ip create -g ${RG} -n WEST-LNXSVR2-PIP -l westus --sku Standard

# NICs
az network nic create -g ${RG} -n EAST-LNXSVR1-NIC --vnet-name ${RG}-PvNET-1 \
    --subnet ${RG}-Subnet-1 --network-security-group ${RG}-EAST-NSG-1 \
    --public-ip-address EAST-LNXSVR1-PIP -l eastus

az network nic create -g ${RG} -n WEST-LNXSVR2-NIC --vnet-name ${RG}-PvNET-2 \
    --subnet ${RG}-Subnet-1 --network-security-group ${RG}-WEST-NSG-2 \
    --public-ip-address WEST-LNXSVR2-PIP -l westus

# VM creation (attach NICs)
IMAGE='Canonical:0001-com-ubuntu-server-jammy:22_04-lts:latest'

echo "Creating EAST VM"
az vm create --resource-group ${RG} --name EAST-LNXSVR1 --image $IMAGE \
    --size Standard_D2s_v3 --location eastus \
    --admin-username azure --admin-password "India@123456" \
    --nics EAST-LNXSVR1-NIC --storage-sku StandardSSD_LRS \
    --os-disk-delete-option Delete --nic-delete-option Delete -l eastus

echo "Creating WEST VM"
az vm create --resource-group ${RG} --name WEST-LNXSVR2 --image $IMAGE \
    --size Standard_D2s_v3 --location westus \
    --admin-username azure --admin-password "India@123456" \
    --nics WEST-LNXSVR2-NIC --storage-sku StandardSSD_LRS \
    --os-disk-delete-option Delete --nic-delete-option Delete -l westus



🔹 Retry procedure if one VM fails
List leftovers:

bash
az network public-ip list -g ${RG} -o table
az network nic list -g ${RG} -o table
az disk list -g ${RG} -o table

Delete only failed VM’s NIC/PIP/OS disk:

bash
az network public-ip delete -g ${RG} -n WEST-LNXSVR2-PIP || true
az network nic delete -g ${RG} -n WEST-LNXSVR2-NIC || true
az disk delete -g ${RG} -n WEST-LNX