# para generar este archivo
# .auto.tfvars: es la parte importante
# <nombre> para este ejemplo se usa "vm"
# <nombre>.auto.tfvars
# vm.auto.tfvars

# sobreescribe el valor: default = "e2-micro"
# variable "machine_type" en archivo 1-variables.tf

# la jerarquia funciona segun el contenido de los archivos
# * vm.auto.tfvars (el primero en asignar valores a las variables utilizadas)
# * terraform.tfvars (el segundo en asignar valores a las variables utilizadas si no exste el archivo [<nombre>.auto.tfvars])
# * 1-variables.tf (si no existen los dos primeros este archivo asina los valores default)

# machine_type  = "e2-medium"