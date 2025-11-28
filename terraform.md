# Terraform Workflow

* HCL - HashiCorp Language - Terraform

* Note: Es necesario que Compute engine API este activada en el proyecto que se eset trabajando.
  * para ver la configuracion creada se revisa el archivo __terraform.tfstate__
  * no eliminar este archivo de configuracion

## Terraform Commands

* terraform init
  * inicializa un directorio para trabajar con los archivos de configuracion de terraform.

* terraform validate
  * Valida los archivos de configuracion de terrafomr, para que la sitaxis sea correta y consistente.

* terraform plan
  * Crea un plan de ejecucion, determina que acciones se realizaran para obtener el estado desceado que se especifico en los archivos de configuracion.
  * crea un plan para saber que recursos seran creados, para ser usados en la nube.

* terraform apply
  * Se utiliza para aplicar los cambios requeridos para lograr el objetivo de la configuracion.
  * una vez ejecutado este comando se crearan los recursos establecidos en los archivos de configuracion.

* terraform destroy
  * Se utiliza para eliminar la infraestructura creada por terrafomr.
  * elimina todos los recursos creados en la nube.
  * solicitara confirmacion para evitar cualquier situacion no decsceada+
  * comando: terraform destroy -auto-approve




* para limpiar la carpeta contenedora, una vez eliminados los recursos:
  * rm -rf .terraform* terraform.tfstate*



La lógica detrás de crear un clúster GKE con Terraform en GCP se basa en cuatro pilares fundamentales: 
1. Declaración, 
2. Orquestación de Dependencias, 
3. Inmutabilidad de la Infraestructura, 
4. y Adopción del Modelo VPC Nativo de GKE.



## Master Terraform on GCP GKE: 40 Real-World Demos to become a DevOps SRE and IaC Expert

### DEMO 01 - install CLI Tools: Gcloud CLI, Terraform CLI & VSCODE Editor

### DEMO 02 - Terraform Commands (Init, Validate, Plan, Apply & Destroy)

### DEMO 03 - Terraform Language Basics

* https://developer.hashicorp.com/terraform/language/block/terraform
* https://developer.hashicorp.com/terraform/language/providers
* https://developer.hashicorp.com/terraform/language/resources


* https://developer.hashicorp.com/terraform/language/resources
* https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network
* https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_subnetwork


* https://docs.cloud.google.com/compute/docs/reference/rest/v1/networks
* https://cloud.google.com/vpc/docs/vpc?hl=es
* https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall


* https://developer.hashicorp.com/terraform/language/meta-arguments
* https://developer.hashicorp.com/terraform/language/meta-arguments/depends_on
* https://developer.hashicorp.com/terraform/tutorials/configuration-language/for-each
* https://developer.hashicorp.com/terraform/tutorials/state/resource-lifecycle
* https://developer.hashicorp.com/terraform/tutorials/0-13/count
* https://developer.hashicorp.com/terraform/language/meta-arguments/provider
* https://developer.hashicorp.com/terraform/language/meta-arguments/providers


# Outputs

* https://developer.hashicorp.com/terraform/language/values/outputs 

- Son valores que se muestran como si se utilizara una instruccion "return"
- proporcionan informacion sobre la infraestructura en una linea de comandos por medio de la salida en CLI.
- al terminar el terraform apply regresa los valores que fueron configurados como "output"
- maneja atributos y argumentos
- output <nombreResource> { Instrucciones para regresar un valor para los atributos indicados }


### Meta Arguments

+ Meta-arguments are a class of arguments built into the Terraform configuration language that control how Terraform creates and manages your infrastructure.
+ You can use meta-arguments in any type of resource. 
+ You can also use most meta-arguments in module blocks.





* depends_on: maneja los recursos ocultos o las dependencias de los modulos, que terraform no puede inerfir
* count: crea o administra varios objetos similares
* for_each: para crear multiples instancias de acuerdo a un mapeo o un conjunto de cadenas(Strings)
* Provider: sirve para sobreescribir el proveedor por default
* lifecycle: define el tiempo de vida del recurso




* se creara una VPC
  * una Subnet
* con dos Reglas de Firewall 
  * fw_ssh22
  * fw_http80


### Query infraesctructure data
* https://developer.hashicorp.com/terraform/language/data-sources
* https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/compute_zones



*  Data Source: permite a terraform utilizar informacion definida fuera de terraform
*  es definen en "Data Blocks"
*  ej: data "google_compute_zones" "available" {
   *  status = "UP"
*  }

#### Argument Reference

* project: (Optional) Project from which to list available zones. Defaults to project declared in the provider.
* region: (Optional) Region from which to list available zones. Defaults to project declared in the provider.
* status: (Optional) Allows to filter list of zones based on their current status.
  * Status ca be either "UP" or "DOWN". Defaults no filtering (all available zones - both "UP" and "DOWN")


###   Terraform Destroy
terraform destroy --auto-approve
[or]
terraform apply --destroy --auto-approve



#### Terraform Destroy
terraform plan -destroy  # You can view destroy plan using this command
terraform destroy

#### Clean-Up Files
rm -rf .terraform*
rm -rf terraform.tfstate*




### Input Variables

* Permiten la customizacion de los recursos o modulos de Terraform si alterar el codigo origen. 
* Permite la reutilizacion de codigo solo cambiando las variables

#### se Tienen multiples opciones para declarar variables

* variables.tf (Default Values)
* terraform.tfvars (Setea y Asigna valores)
* vm.auto.tfvars (define variables para recursos especificos, los valores se aplican en automatico)
* vm.tfvars (si se usa de esta forma es necesario especificar Environment Variables )
* Environment Variables
  * --var-file flag
  * --var flag





### GCP Google Cloud Platform - Terraform Meta-Argument Count

Terraform Meta-argument count
For Loop with List
For Loop with Map
For Loop with Map Advanced
Legacy Splat Operator (latest) - Returns List
Latest Generalized Splat Operator - Returns the List

