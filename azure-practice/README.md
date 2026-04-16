===============Terraform Workflow=============  
terraform init
terraform fmt
terraform validate
terraform plan
terraform apply  # terraform apply --auto-approve
terraform destroy  # terraform destroy --auto-approve  

========= Terraform Resource Creation Syntax==========
resource "type-of resource" "name-of-resource" {
    arg1 = ?
    arg2 = ?
    arg3 = ?
}

Everything ease when you go through Terrafrom Documentaion---

resource "azurerm_resource_group" "example" {
  name     = "ResourceGroup1"
  location = "East US"

  tags = {
    environment = "Production"
  }
}

# Terraform Azure Credentials for Environment variables Documentaion

PowerShell Service Principle authentication

# PowerShell
 $env:ARM_CLIENT_ID = "00000000-0000-0000-0000-000000000000"
 $env:ARM_CLIENT_SECRET = "12345678-0000-0000-0000-000000000000"
 $env:ARM_TENANT_ID = "10000000-0000-0000-0000-000000000000"
 $env:ARM_SUBSCRIPTION_ID = "20000000-0000-0000-0000-000000000000"

# bash:--------

export ARM_CLIENT_ID="00000000-0000-0000-0000-000000000000"
export ARM_CLIENT_SECRET="12345678-0000-0000-0000-000000000000"
export ARM_TENANT_ID="10000000-0000-0000-0000-000000000000"
export ARM_SUBSCRIPTION_ID="20000000-0000-0000-0000-000000000000"

# Terrafor class -1 Topics----
1-- Understand Terraform providers and How thry work.
2-- Create Azure SP (service policy) and provide access at Management group level.
3-- Generate credential for SP and set as ENV variables.
4-- Understand Terraform parallelism and terraform apply --auto-approve -parallelism=1
-- 
5--------Terraform implicit and explicit dependency
6-- Implicit dependency can be decided by Terraform default. ex vNET creation...
7-- user need to configure Explicit dependency using 
'depends_on'         statement
8  eg: SP1-RG depends_on HUB-RG   
9-- terraform apply --auto-approve
10- terraform remote state in storage account.
11- terraform state lock testing
12- list of resources displayes terraform previously created with state commands
13- terraform state list 
$ terraform state list
azurerm_resource_group.HUB_RG
azurerm_resource_group.SP1_RG
azurerm_resource_group.SP2_RG
azurerm_subnet.vNET-subnet-1
azurerm_subnet.vNET-subnet-2
azurerm_subnet.vNET-subnet-3
azurerm_virtual_network.vNET


list all resources names throguh state file
14- $ terraform state pull |jq ".resources[].name" -r
HUB_RG
SP1_RG
SP2_RG
vNET-subnet-1
vNET-subnet-2
vNET-subnet-3
vNET


15- If you want to rename in created resource group use mv command in terraform 

 terraform state mv azurerm_resource_group.SP2_RG azurerm_resource_group.SP2_RG1Acquiring state lock. This may take a few moments...
Move "azurerm_resource_group.SP2_RG" to "azurerm_resource_group.SP2_RG1"
Successfully moved 1 object(s).
Releasing state lock. This may take a few moments...

Terraform Variables Declaration and tfvars.............

===========================================================

class --2

1 Access existing keyValuts uisng Data sources.
2 Deploy NSG and Virtual Machines.
3 Understand LIfe Cycle policies.... 
4 Terraform Functions...
   -count
   -Lenght
   -map
   -lookup
   -condition






azure-practice/
 ├── 1.provider.tf
 ├── 2.variables.tf        # schema only (no defaults)
 ├── 3.terraform.tfvars    # optional, for local dev
 ├── dev.tfvars            # dev environment values
 ├── test.tfvars           # test environment values
 ├── prod.tfvars           # prod environment values
 ├── 4.nsg.tf
 ├── 5.main.tf
 ├── 6.random_passwords.tf
 └── .gitignore

 azure-practice/
 ├── 1.provider.tf
 ├── 2.variables.tf        # schema only
 ├── dev.tfvars
 ├── test.tfvars
 ├── prod.tfvars
 ├── 3.terraform.tfvars    # optional local default
 ├── 4.nsg.tf
 ├── 5.main.tf
 ├── 6.random_passwords.tf
 └── .gitignore


test.tfvars

hub_rg_name             = "AZB50-HUB-RG-TEST"
location                = "East US"
owner                   = "QA Team"
environment             = "Testing"
managed_by              = "Terraform"
vNET_cidr_block         = ["10.20.0.0/16"]
vNET_subnet1_cidr_block = ["10.20.1.0/24"]
vNET_subnet2_cidr_block = ["10.20.2.0/24"]
vNET_subnet3_cidr_block = ["10.20.3.0/24"]

terraform plan -var-file="test.tfvars"
terraform apply -var-file="test.tfvars"


dev.tfvars

hub_rg_name             = "AZB50-HUB-RG-DEV"
location                = "East US"
owner                   = "DevOps Team"
environment             = "Development"
managed_by              = "Terraform"
vNET_cidr_block         = ["10.1.0.0/16"]
vNET_subnet1_cidr_block = ["10.1.1.0/24"]
vNET_subnet2_cidr_block = ["10.1.2.0/24"]
vNET_subnet3_cidr_block = ["10.1.3.0/24"]

terraform plan -var-file="dev.tfvars"
terraform apply -var-file="dev.tfvars"

prod.tfvars

hub_rg_name             = "AZB50-HUB-RG-PROD"
location                = "East US"
owner                   = "CloudOps Team"
environment             = "Production"
managed_by              = "Terraform"
vNET_cidr_block         = ["10.50.0.0/16"]
vNET_subnet1_cidr_block = ["10.50.1.0/24"]
vNET_subnet2_cidr_block = ["10.50.2.0/24"]
vNET_subnet3_cidr_block = ["10.50.3.0/24"]



terraform plan -var-file="prod.tfvars"
terraform apply -var-file="prod.tfvars"


# How Terraform Picks Up .tfvars
By default, Terraform automatically loads a file named terraform.tfvars or *.auto.tfvars in the working directory.

Since you named yours 3.terraform.tfvars, you need to explicitly tell Terraform to use it:

bash
terraform plan -var-file="3.terraform.tfvars"
terraform apply -var-file="3.terraform.tfvars"
If you rename it to terraform.tfvars, you won’t need the -var-file flag — Terraform will pick it up automatically.

🧠 Best Practice
Keep variables.tf as a schema only (no defaults).

Use separate .tfvars files for environments:

dev.tfvars

test.tfvars

prod.tfvars

Run with:

bash
terraform plan -var-file="prod.tfvars"
Add .tfvars and state files to .gitignore so they never get pushed to GitHub:

Code
*.tfvars
*.tfstate
*.tfstate.backup
crash.log
👉 Since you already have 3.terraform.tfvars, you can either keep using -var-file or rename it to terraform.tfvars for automatic loading.