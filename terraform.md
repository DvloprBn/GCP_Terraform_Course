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
* 

* se creara una VPC
  * una Subnet
* con dos Reglas de Firewall 
  * fw_ssh22
  * fw_http80







