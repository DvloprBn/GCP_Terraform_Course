
# se ejecuta desde consola
# esto es para ambientes Linux o Unix 


# Comment machine_type in terraform.tfvars
#machine_type  = "e2-micro"

# Set Environment Variable
export TF_VAR_machine_type="e2-standard-2"
echo $TF_VAR_machine_type

# Run Terraform Plan
terraform plan
Observation: Machine type configured will be "e2-standard-2" from environment variable set

# Unset Environment variable
unset TF_VAR_machine_type
echo $TF_VAR_machine_type

# Run Terraform Plan
terraform plan
Observation: Machine type configured will be "e2-small" from variables.tf default value

# Variable Precendence
Priority-1: Any -var and -var-file options on the command line, in the order they are provided. 
Priority-2: Any *.auto.tfvars or *.auto.tfvars.json files, processed in lexical order of their filenames.
Priority-3: The terraform.tfvars.json file, if present.
Priority-4: The terraform.tfvars file, if present.
Priority-5: Environment variables

# Comment machine_type in terraform.tfvars
machine_type  = "e2-micro"






## Execute Terraform Commands
# Terraform Initialize
terraform init
Observation:
1) Initialized Local Backend
2) Downloaded the provider plugins (initialized plugins)
3) Review the folder structure ".terraform folder"

# Terraform Validate
terraform validate
Observation:
1) If any changes to files, those will come as printed in stdout (those file names will be printed in CLI)

# Terraform Plan
terraform plan
1) Verify the number of resources that going to get created
2) Verify the variable replacements worked as expected

# Terraform Apply
terraform apply 
[or]
terraform apply -auto-approve
Observations:
1) Create resources on cloud
2) Created terraform.tfstate file when you run the terraform apply command



### Access Application

# Access index.html
http://<EXTERNAL-IP>/index.html
http://<EXTERNAL-IP>/app1/index.html




#### Clean-Up
# Terraform Destroy
terraform plan -destroy  # You can view destroy plan using this command
terraform destroy

# Clean-Up Files
rm -rf .terraform*
rm -rf terraform.tfstate*