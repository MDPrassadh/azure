Challanges with HUB and SPOKE Architecture:
###########################################
1. Single point of failure: The hub can be a single point of failure.
2. Potential bottlenecks: If not configured or scaled properly, the hub can become a performance bottleneck.
3. Latency: All traffic passes through the hub, which can add latency.
4. Limited virtual network peerings as max vNET Peerings are 500 per vNET.
5. Bandwidth and latency limits: Traffic is limited to the bandwidth of the ExpressRoute gateway SKU size and latency of hair-pinning.

Instructions for the lab:
1. Create a hub virtual network with subnets for Azure Firewall, Azure Bastion, and VPN Gateway.
2. Create two spoke virtual networks, each with a subnet for virtual machines.
3. Create NSGs and associate them with the subnets.
4. Create virtual machines in the spoke virtual networks and ensure they do not have public IP addresses.
5. Create VNet peerings between the hub and spoke virtual networks, and between the spoke virtual networks themselves.
6. Create route tables in the spoke virtual networks and add routes to direct traffic to the Azure Firewall in the hub virtual network.
7. Associate the route tables with the subnets in the spoke virtual networks.
8. Deploy an Azure Firewall in the hub virtual network and configure it to allow traffic between the spoke virtual networks and to the internet.    

Instrcutions for vms sizes according to my subscription limits:
1. For the hub virtual network, you can use Standard_D2s_v3 size for the virtual machines. This size is suitable for the Azure Firewall and Azure Bastion host.
2. For the spoke virtual networks, you can also use Standard_D2s_v3 size for the virtual machines. This size is sufficient for the virtual machines in the spoke virtual networks, which are typically used for testing and development purposes in a lab environment.  

==============VM Families You Can Safely Use=======================================
From your quota snapshot:

DSv3 Family → Limit 10 vCPUs, 6 already in use

DCSv2 Family → Limit 8 vCPUs, none in use

Easv7 / Eadsv7 / Esv6 / Edsv6 Families → Limit 10 vCPUs each

Ev3 / Ev4 Families → Limit 10 vCPUs each

F Series (F, FS, FSv2, Famdsv7, Famsv7, etc.) → Limit 10 vCPUs each

Basic A / Av2 / A0–A7 Families → Limit 10 vCPUs each

NV Family → Limit 12 vCPUs

H Family → Limit 8 vCPUs

🔹 Best Practice VM Sizes for Learning
===========Windows Server=================================
Standard_D2s_v3 → 2 vCPUs, 8 GB RAM

Good for Windows Server 2022 practice, AD DS, IIS, SQL basics.

Standard_E2s_v6 → 2 vCPUs, 16 GB RAM

Better memory footprint for Windows workloads (RDP, GUI apps).

Standard_F2s → 2 vCPUs, 4 GB RAM

Lightweight, good for PowerShell scripting and domain join tests.

Standard_A2_v2 → 2 vCPUs, 4 GB RAM

Entry‑level, useful for basic Windows services.

======================Linux Server==========================
Standard_D2s_v3 → Ubuntu/CentOS practice, Docker, Nginx.

Standard_E2s_v6 → Kubernetes single‑node, memory‑intensive apps.

Standard_F2s → CLI practice, Ansible, Terraform agents.

Standard_A2_v2 → Lightweight Linux VM for SSH, scripting.

🔹 Recommended Practice Flow
Start small:

Windows → Standard_D2s_v3 or Standard_A2_v2.

Linux → Standard_F2s or Standard_A2_v2.
These are safe and won’t exceed quota.

Scale up gradually:

Move to Standard_E2s_v6 or Standard_E4s_v6 when you need more memory.

Use DSv3 family up to 4 cores (since you already consumed 6/10 quota).

Specialized practice:

NV family → GPU workloads (CUDA, ML, graphics).

H family → HPC workloads (parallel computing, simulations).

🔹 My Recommendation for You
For Windows Server labs: stick to D2s_v3 and E2s_v6.

For Linux labs: use F2s and A2_v2 for lightweight practice, scale to E4s_v6 when needed.

Avoid DSv5/ESv5 families until quota is approved.

💡 This way, you’ll maximize your $200 credits and Pay‑As‑You‑Go plan without hitting quota errors.


#HUB RG CREATION
RG='AZB50-HUB-RG'

az group create --location eastus -n ${RG}

# Create VNet (NO default-outbound flag here)
az network vnet create -g ${RG} -n ${RG}-PvNET1 --address-prefix 10.50.0.0/16 \
    --subnet-name JumpServersSubnet --subnet-prefix 10.50.1.0/24 -l eastus

# Disable default outbound on JumpServersSubnet
az network vnet subnet update -g ${RG} --vnet-name ${RG}-PvNET1 -n JumpServersSubnet \
    --default-outbound false

# Create other subnets
az network vnet subnet create -g ${RG} --vnet-name ${RG}-PvNET1 -n AzureFirewallSubnet \
    --address-prefixes 10.50.10.0/24

az network vnet subnet create -g ${RG} --vnet-name ${RG}-PvNET1 -n AzureBastionSubnet \
    --address-prefixes 10.50.20.0/24

az network vnet subnet create -g ${RG} --vnet-name ${RG}-PvNET1 -n GatewaySubnet \
    --address-prefixes 10.50.30.0/24

az network vnet subnet create -g ${RG} --vnet-name ${RG}-PvNET1 -n PvtEndpointSubnet \
    --address-prefixes 10.50.40.0/24


echo "Creating NSG and NSG Rule"
az network nsg create -g ${RG} -n ${RG}_NSG1
az network nsg rule create -g ${RG} --nsg-name ${RG}_NSG1 -n ${RG}_NSG1_RULE1 --priority 100 \
    --source-address-prefixes '*' --source-port-ranges '*' --destination-address-prefixes '*' \
    --destination-port-ranges '*' --access Allow --protocol Tcp --description "Allowing All Traffic For Now"
az network nsg rule create -g ${RG} --nsg-name ${RG}_NSG1 -n ${RG}_NSG1_RULE2 --priority 101 \
    --source-address-prefixes '*' --source-port-ranges '*' --destination-address-prefixes '*' \
    --destination-port-ranges '*' --access Allow --protocol Icmp --description "Allowing ICMP Traffic For Now"

echo "Creating NAT Gateway for HUB outbound"

# Create Public IP for NAT Gateway
az network public-ip create -g AZB50-HUB-RG -n HUB-NAT-PIP --sku Standard -l eastus

# Create NAT Gateway
az network nat gateway create \
  -g AZB50-HUB-RG \
  -n HUB-NATGW \
  --public-ip-addresses HUB-NAT-PIP \
  --idle-timeout 10 \
  -l eastus

# Attach NAT Gateway to HUB subnets
az network vnet subnet update \
  -g AZB50-HUB-RG \
  --vnet-name AZB50-HUB-RG-PvNET1 \
  -n JumpServersSubnet \
  --nat-gateway HUB-NATGW


IMAGE='Canonical:0001-com-ubuntu-server-jammy:22_04-lts:latest'

echo "Creating Virtual Machines"
az vm create --resource-group ${RG} --name HUB-MDPLNX1 --image $IMAGE --vnet-name ${RG}-PvNET1 \
    --subnet JumpServersSubnet --admin-username adminsree --admin-password "India@123456" --size Standard_D2s_v3 \
    --nsg ${RG}_NSG1 --storage-sku StandardSSD_LRS --private-ip-address 10.50.1.10 \
    --os-disk-delete-option Delete --nic-delete-option Delete --security-type TrustedLaunch --public-ip-address ""  # This is to ensure that the VM does not have a public IP address and is only accessible through the hub virtual network. This is important in HUB and SPOKE architecture where we want to control the traffic flow through the HUB and not allow direct access to the VMs in the SPOKEs. By not assigning a public IP address, we can ensure that all access to the VM goes through the hub where we can apply security controls and monitoring.

az vm create --resource-group ${RG} --name HUB-MDPWIN2 --image Win2022Datacenter --vnet-name ${RG}-PvNET1 \
    --subnet JumpServersSubnet --admin-username adminsree --admin-password "India@123456" --size Standard_D2s_v3 \
    --nsg ${RG}_NSG1 --storage-sku StandardSSD_LRS --private-ip-address 10.50.1.11 \
    --os-disk-delete-option Delete --nic-delete-option Delete --public-ip-address "" --security-type TrustedLaunch   # This is to ensure that the VM does not have a public IP address and is only accessible through the hub virtual network. This is important in HUB and SPOKE architecture where we want to control the traffic flow through the HUB and not allow direct access to the VMs in the SPOKEs. By not assigning a public IP address, we can ensure that all access to the VM goes through the hub where we can apply security controls and monitoring.

#AZB50-SP1-RG CREATION
RG='AZB50-SP1-RG'

az group create --location eastus -n ${RG}

# Create VNet (NO default-outbound flag here)
az network vnet create -g ${RG} -n ${RG}-PvNET1 --address-prefix 172.16.0.0/16 \
    --subnet-name ${RG}-Subnet-1 --subnet-prefix 172.16.1.0/24 -l eastus

# Disable default outbound on Subnet-1
az network vnet subnet update -g ${RG} --vnet-name ${RG}-PvNET1 \
    -n ${RG}-Subnet-1 --default-outbound false

# Create Subnet-2 (NO default-outbound flag here)
az network vnet subnet create -g ${RG} --vnet-name ${RG}-PvNET1 -n ${RG}-Subnet-2 \
    --address-prefixes 172.16.2.0/24

# Disable default outbound on Subnet-2
az network vnet subnet update -g ${RG} --vnet-name ${RG}-PvNET1 \
    -n ${RG}-Subnet-2 --default-outbound false


echo "Creating NSG and NSG Rule"
az network nsg create -g ${RG} -n ${RG}_NSG1
az network nsg rule create -g ${RG} --nsg-name ${RG}_NSG1 -n ${RG}_NSG1_RULE1 --priority 100 \
    --source-address-prefixes '*' --source-port-ranges '*' --destination-address-prefixes '*' \
    --destination-port-ranges '*' --access Allow --protocol Tcp --description "Allowing All Traffic For Now"
az network nsg rule create -g ${RG} --nsg-name ${RG}_NSG1 -n ${RG}_NSG1_RULE2 --priority 101 \
    --source-address-prefixes '*' --source-port-ranges '*' --destination-address-prefixes '*' \
    --destination-port-ranges '*' --access Allow --protocol Icmp --description "Allowing ICMP Traffic For Now"

echo "Creating NAT Gateway for SP1 outbound"

# Create Public IP for NAT Gateway
az network public-ip create -g AZB50-SP1-RG -n SP1-NAT-PIP --sku Standard -l eastus

# Create NAT Gateway
az network nat gateway create \
  -g AZB50-SP1-RG \
  -n SP1-NATGW \
  --public-ip-addresses SP1-NAT-PIP \
  --idle-timeout 10 \
  -l eastus

# Attach NAT Gateway to SP1 subnets
az network vnet subnet update \
  -g AZB50-SP1-RG \
  --vnet-name AZB50-SP1-RG-PvNET1 \
  -n AZB50-SP1-RG-Subnet-1 \
  --nat-gateway SP1-NATGW

az network vnet subnet update \
  -g AZB50-SP1-RG \
  --vnet-name AZB50-SP1-RG-PvNET1 \
  -n AZB50-SP1-RG-Subnet-2 \
  --nat-gateway SP1-NATGW

RG='AZB50-SP1-RG'
IMAGE='Canonical:0001-com-ubuntu-server-jammy:22_04-lts:latest'

echo "Creating Virtual Machines"
az vm create --resource-group ${RG} --name SP1-LNXSVR1 --image $IMAGE --vnet-name ${RG}-PvNET1 \
    --subnet ${RG}-Subnet-1 --admin-username adminsree --admin-password "India@123456" --size Standard_D2s_v3 \
    --nsg ${RG}_NSG1 --storage-sku StandardSSD_LRS --private-ip-address 172.16.1.10 \
    --os-disk-delete-option Delete --nic-delete-option Delete --public-ip-address ""

#Private Server
az vm create --resource-group ${RG} --name SP1-LNXSVR2 --image $IMAGE --vnet-name ${RG}-PvNET1 \
    --subnet ${RG}-Subnet-2 --admin-username adminsree --admin-password "India@123456" --size Standard_D2s_v3 \
    --nsg ${RG}_NSG1 --storage-sku StandardSSD_LRS --private-ip-address 172.16.2.10 \
    --os-disk-delete-option Delete --nic-delete-option Delete --public-ip-address ""


az vm create --resource-group ${RG} --name SP1-WINSVR3 --image Win2022Datacenter --vnet-name ${RG}-PvNET1 \
    --subnet ${RG}-Subnet-1 --admin-username adminsree --admin-password "India@123456" --size Standard_D2s_v3 \
    --nsg ${RG}_NSG1 --storage-sku StandardSSD_LRS --private-ip-address 172.16.1.11 \
    --os-disk-delete-option Delete --nic-delete-option Delete --public-ip-address ""


#AZB50-SP2-RG CREATION
RG='AZB50-SP2-RG'

az group create --location westus -n ${RG}

# Create VNet (NO default-outbound flag here)
az network vnet create -g ${RG} -n ${RG}-PvNET1 --address-prefix 172.17.0.0/16 \
    --subnet-name ${RG}-Subnet-1 --subnet-prefix 172.17.1.0/24 -l westus

# Disable default outbound on Subnet-1
az network vnet subnet update -g ${RG} --vnet-name ${RG}-PvNET1 \
    -n ${RG}-Subnet-1 --default-outbound false

# Create Subnet-2 (NO default-outbound flag here)
az network vnet subnet create -g ${RG} --vnet-name ${RG}-PvNET1 -n ${RG}-Subnet-2 \
    --address-prefixes 172.17.2.0/24

# Disable default outbound on Subnet-2
az network vnet subnet update -g ${RG} --vnet-name ${RG}-PvNET1 \
    -n ${RG}-Subnet-2 --default-outbound false
 

echo "Creating NSG and NSG Rule"
az network nsg create -g ${RG} -n ${RG}_NSG1 -l westus
az network nsg rule create -g ${RG} --nsg-name ${RG}_NSG1 -n ${RG}_NSG1_RULE1 --priority 100 \
    --source-address-prefixes '*' --source-port-ranges '*' --destination-address-prefixes '*' \
    --destination-port-ranges '*' --access Allow --protocol Tcp --description "Allowing All Traffic For Now"
az network nsg rule create -g ${RG} --nsg-name ${RG}_NSG1 -n ${RG}_NSG1_RULE2 --priority 101 \
    --source-address-prefixes '*' --source-port-ranges '*' --destination-address-prefixes '*' \
    --destination-port-ranges '*' --access Allow --protocol Icmp --description "Allowing ICMP Traffic For Now"

echo "Creating NAT Gateway for SP2 outbound"

# Create Public IP for NAT Gateway
az network public-ip create -g AZB50-SP2-RG -n SP2-NAT-PIP --sku Standard -l westus

# Create NAT Gateway
az network nat gateway create \
  -g AZB50-SP2-RG \
  -n SP2-NATGW \
  --public-ip-addresses SP2-NAT-PIP \
  --idle-timeout 10 \
  -l westus

# Attach NAT Gateway to SP2 subnets
az network vnet subnet update \
  -g AZB50-SP2-RG \
  --vnet-name AZB50-SP2-RG-PvNET1 \
  -n AZB50-SP2-RG-Subnet-1 \
  --nat-gateway SP2-NATGW

az network vnet subnet update \
  -g AZB50-SP2-RG \
  --vnet-name AZB50-SP2-RG-PvNET1 \
  -n AZB50-SP2-RG-Subnet-2 \
  --nat-gateway SP2-NATGW

RG='AZB50-SP2-RG'
IMAGE='Canonical:0001-com-ubuntu-server-jammy:22_04-lts:latest'

echo "Creating Virtual Machines"
az vm create --resource-group ${RG} --name SP2-GBRLNX1 --location westus --image $IMAGE --vnet-name ${RG}-PvNET1 \
    --subnet ${RG}-Subnet-1 --admin-username adminsree --admin-password "India@123456" --size Standard_D2s_v3 \
    --nsg ${RG}_NSG1 --storage-sku StandardSSD_LRS --private-ip-address 172.17.1.10 \
    --os-disk-delete-option Delete --nic-delete-option Delete --public-ip-address ""        # any thing last "" like --public-ip-address "" is to avoid creating public IP for the VM and make it private only. 
    # This is important in HUB and SPOKE architecture where we want to control the traffic flow through the HUB and not allow direct access to the VMs in the SPOKEs.   

az vm create --resource-group ${RG} --name SP2-GBRWIN2 --image Win2022Datacenter --vnet-name ${RG}-PvNET1 \
    --subnet ${RG}-Subnet-1 --admin-username adminsree --admin-password "India@123456" --size Standard_D2s_v3 \
    --nsg ${RG}_NSG1 --storage-sku StandardSSD_LRS --private-ip-address 172.17.1.11 \
    --os-disk-delete-option Delete --nic-delete-option Delete --security-type TrustedLaunch --public-ip-address ""

##################################################
#VNET-PEERINGS
VNet1Id=$(az network vnet show --resource-group AZB50-HUB-RG --name AZB50-HUB-RG-PvNET1 --query id --out tsv)
VNet2Id=$(az network vnet show --resource-group AZB50-SP1-RG --name AZB50-SP1-RG-PvNET1 --query id --out tsv)
VNet3Id=$(az network vnet show --resource-group AZB50-SP2-RG --name AZB50-SP2-RG-PvNET1 --query id --out tsv)

#HUBRG-to-SPOKE1
az network vnet peering create -g AZB50-HUB-RG -n HUB-to-SP1 --vnet-name AZB50-HUB-RG-PvNET1 --remote-vnet $VNet2Id --allow-vnet-access
az network vnet peering create -g AZB50-SP1-RG -n SP1-to-HUB --vnet-name AZB50-SP1-RG-PvNET1 --remote-vnet $VNet1Id --allow-vnet-access
#HUBRG-to-SPOKE2
az network vnet peering create -g AZB50-HUB-RG -n HUB-to-SP2 --vnet-name AZB50-HUB-RG-PvNET1 --remote-vnet $VNet3Id --allow-vnet-access
az network vnet peering create -g AZB50-SP2-RG -n SP2-to-HUB --vnet-name AZB50-SP2-RG-PvNET1 --remote-vnet $VNet1Id --allow-vnet-access
#SPOKE1-to-SPOKE2
az network vnet peering create -g AZB50-SP1-RG -n SP1-to-SP2 --vnet-name AZB50-SP1-RG-PvNET1 --remote-vnet $VNet3Id --allow-vnet-access
az network vnet peering create -g AZB50-SP2-RG -n SP2-to-SP1 --vnet-name AZB50-SP2-RG-PvNET1 --remote-vnet $VNet2Id --allow-vnet-access

##################################################
#ROUTE TABLES
az network route-table create -g AZB50-SP1-RG -n SPOKE1-RT
az network route-table create -g AZB50-SP2-RG -n SPOKE2-RT

#ADDING ROUTES
az network route-table route create -g AZB50-SP1-RG --route-table-name SPOKE1-RT -n TO-FIREWALL --next-hop-type VirtualAppliance --address-prefix 0.0.0.0/0 --next-hop-ip-address 10.1.10.4
az network route-table route create -g AZB50-SP2-RG --route-table-name SPOKE2-RT -n TO-FIREWALL --next-hop-type VirtualAppliance --address-prefix 0.0.0.0/0 --next-hop-ip-address 10.1.10.4

#ADD ROUTE TABLE TO SUBNETS
az network vnet subnet update --name AZB50-SP1-RG-Subnet-1 --vnet-name AZB50-SP1-RG-PvNET1 --route-table SPOKE1-RT -g AZB50-SP1-RG
az network vnet subnet update --name AZB50-SP2-RG-Subnet-1 --vnet-name AZB50-SP2-RG-PvNET1 --route-table SPOKE2-RT -g AZB50-SP2-RG

#DEPLOY AZURE FIREWALL
#az network firewall create --name AZ-FW1 -g AZB50-HUB-RG --private-ranges 10.1.0.0/16 --location eastus --sku AZFW_VNet

az network vnet-gateway create -g AZB50-HUB-RG -n VNG1 --public-ip-address VNG1-PIP \
    --vnet AZB50-HUB-RG-PvNET1 --gateway-type Vpn --sku VpnGw1 --vpn-type RouteBased --no-wait
