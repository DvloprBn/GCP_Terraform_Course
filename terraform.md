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

* rm -rf .terraform*
* rm -rf terraform.tfstate*



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




## GKE
### GKE Cluster Modes & Types

* Modes
  * GKE standard
  * GKE Autopilot
  * 
* Types
  * GKE Zonal Cluster
  * GKE Regional Cluster
  * GKE Public Cluster
  * GKE Private Cluster
  * GKE Alpha Cluster
  * GKE Cluster using Windows Node Pools


- GKE Standard Public Cluster     - Network Design
  - Google Managed VPC Network    - Project id
    - Google Managed VPC Network  - MyVPC
      - Region: us-central1       - Region
        - GKE Control Plane       - GKE Cluster
          - Kube API Server Public IP
          - Kube-apiserver
          - kube-scheduler
          - Resource Controllers
          - Storage



+ Peoject
  + Customer VPC: myVPC
    + Region: us-central1
      + Gke Cluster
        + Subnet: 10.128.0.0/20
          + Zone: us-central1-a
            + Gke Node-1
              + Public IP
              + Private IP
          + Zone: us-central1-b
            + Gke Node-2
              + Public IP
              + Private IP





#### Definicion Terraform VPC, GKE, VM & Psql

* Resoruces
  * google_compute_network
  * google_compute_subnetwork
  * google_compute_firewall
  * google_container_cluster
  * google_container_node_pool
  * google_compute_instance
  * google_sql_database_instance
  * google_sql_database

##### Orden de Creación Típico: 
  * VPC/Subred  
      * -> Cloud SQL Peering/Instancia PSQL 
          * -> Cluster GKE 
              * -> VM.

  + Garantía de Convergencia: 
      + Llama a las APIs de GCP para crear los recursos. Espera activamente a que cada recurso se encuentre en un estado funcional antes de pasar al siguiente. Por ejemplo, no intentará crear los nodos de GKE hasta que el plano de control (el Master) del cluster esté completamente disponible.

  + Actualización del Estado: 
      + Una vez que un recurso se ha creado con éxito en GCP, Terraform guarda su identidad, configuración y atributos en el archivo de estado (terraform.tfstate). Este archivo es crítico para la gestión futura de la infraestructura.



A. Definición de Red (VPC)
    Recurso Clave: __google_compute_network (VPC)__ y __google_compute_subnetwork (Subred)__.

    Teoría: Se define primero una red VPC y al menos una subred dentro de ella. Esta red será el entorno de conectividad para todos los demás recursos.

    Dependencias: Ninguna (es la base).


B. Creación del Cluster GKE
    Recurso Clave: __google_container_cluster__ y __google_container_node_pool__.

    Teoría: El cluster de GKE se define para operar dentro de la VPC y la subred creadas. Los nodos de GKE (que son VMs) deben ser creados en esa subred específica para comunicarse con la red del proyecto.

    Dependencias: El cluster de GKE depende de la existencia previa de la VPC y la Subred. Se referencian explícitamente en la configuración de GKE.

C. Creación de la VM (Servidor de Aplicaciones)
    Recurso Clave: __google_compute_instance__.

    Teoría: La VM se define para actuar como un servidor de aplicaciones o cualquier componente auxiliar. Al igual que GKE, debe ser configurada para usar la VPC y la Subred correctas para asegurar la conectividad interna.

    Dependencias: La VM depende de la existencia previa de la VPC y la Subred.

D. Creación de la Instancia de PostgreSQL (Cloud SQL)
    Recurso Clave: __google_sql_database_instance__ y __google_sql_database__.

    Teoría: Cloud SQL es un servicio gestionado, por lo que no reside directamente en una subred de la VPC como las VMs. En su lugar, usa un mecanismo de Acceso a Servicio Privado (Private Service Access - PSA) o VPC Peering.

    Para que la VM y el cluster GKE puedan acceder a la base de datos de forma privada, Terraform debe configurar el peering de la VPC entre tu red y la red interna de servicios de Google.

Dependencias:

    La instancia de Cloud SQL depende de la VPC para establecer el peering.

    La base de datos (lógica) depende de la instancia (física).





### TAGS

Los Tags (etiquetas) en una configuración de recursos de Terraform para Google Cloud Platform (GCP) se utilizan principalmente para dos propósitos clave: Redes (Firewall) y Organización/Metadatos.

Aquí tienes una explicación detallada de cada uso:

1. 🌐 Uso en Redes (Firewall Rules)
Este es el uso más crítico de los tags en recursos como las instancias de Compute Engine (google_compute_instance) o los nodos de un cluster GKE.

¿Qué son? Un tag es una etiqueta de texto simple que asignas a un recurso de red (como una VM).

¿Para qué sirven? Las Reglas de Firewall de VPC (google_compute_firewall) utilizan estos tags como selectores de destino y selectores de origen.

Funcionamiento:

Creas una instancia de VM y le asignas un tag, por ejemplo, app-server.

Creas una regla de firewall que dice: "Permitir el tráfico TCP en el puerto 8080 desde cualquier lugar a cualquier instancia que tenga el tag app-server."

Esto te permite aplicar políticas de seguridad a un grupo de máquinas con una característica o rol común, sin tener que referenciar sus direcciones IP individuales.

Ejemplo Teórico
Si tienes 50 VMs que ejecutan un servidor web, solo necesitas asignarles el tag http-server. Luego, defines una sola regla de firewall que permite el tráfico HTTP (:80) a todas las instancias con ese tag.

2. 🏷️ Uso en Organización y Metadatos
Aunque el término "tag" en el contexto de las VMs de Compute Engine se refiere a las etiquetas de red, a menudo se confunde con las Labels (Etiquetas), las cuales tienen un propósito organizacional más amplio, especialmente en otros recursos de GCP (como Cloud SQL, Buckets de Storage, etc.).


---


un datasource es lo mismo que un bloque de datos

data "terraform_remote_state" "gke" {
  
}







---



Investigar bien sobre los snapshot

relacionado con terraform

---