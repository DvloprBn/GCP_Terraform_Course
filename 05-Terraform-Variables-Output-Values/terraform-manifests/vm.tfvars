# Variable Definition Option: vm.tfvars
# para este archivo es necesario pasar las variables desde consola
# o al ejecutar el script

# file
# vm.tfvars

# ----------------------------------------------------------------------------------

# valor a ser utilizado
# machine_type  = "e2-standard-8"


# ----------------------------------------------------------------------------------


# Terraform Plan
# Observation:
# terraform plan
# 1. Review VM Instance machine_type
# 2. It should be loaded from vm.auto.tfvars
# 3. We need to explicity pass the vm.tfvars to terraform commands
# 
# # Terraform plan
# inidica de que archivo va a tomar los valores para las variables
# terraform plan --var-file=vm.tfvars
# Observation:
# 1. Review VM Instance machine_type
# 2. It should be loaded from vm.tfvars whose value is e2-standard-8
# 3. In short, what-ever we pass via --var-file or --var flags will be having higher priority than anyother options


# Variable Definition Option: Directly pass it in command
# Terraform plan
# terraform plan --var=machine_type=e2-standard-4
# inidica que sustituira una variable
# --var=
# inidca el nombre de la variable que cambiara de valor
# machine_type
# inidica el nuevo valor para la variable
# =e2-standard-4
# Observation:
# 1. Review VM Instance machine_type
# 2. It should be loaded from the command whose value is e2-standard-4