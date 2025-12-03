- https://developer.hashicorp.com/terraform/language/values/locals

* para este ejercicio es necesario crear un bucket en GCP 


## GKE

## Service Account
* https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_service_account


  - __"Una Cuenta de Servicio es una identidad especial que utilizas para que una aplicación o componente de la plataforma pueda hacer llamadas a las APIs de Google Cloud sin depender de una cuenta de usuario final (humana)."__
  - Piensa en ella como una __"identidad no humana"__ o un __usuario robot__ dentro de tu proyecto de GCP.
  - Una Cuenta de Servicio de Cloud (Cloud Service Account) es fundamentalmente una identidad cuyo propósito principal es controlar los permisos y accesos de los componentes de tu aplicación o infraestructura dentro de GCP.


* Componente & Uso de la Cuenta de Servicio

1. VM de Compute Engine
   1. Le permite a la VM leer datos de Cloud Storage o escribir logs en Cloud Logging.

2. Función de Cloud Functions
   1. Le da permiso a la función para publicar un mensaje en un tema de Cloud Pub/Sub.

3. Cluster de GKE
   1. Permite a los nodos del cluster (las VMs que lo componen) descargar imágenes de Container Registry.



### Característica	& Propósito de la Cuenta de Servicio

1. Control de Permisos (IAM):
   1. Funciona como un principal (miembro) al que puedes asignar roles de IAM. Estos roles definen qué puede hacer (ej. leer un bucket, crear una VM) y a qué recursos tiene acceso.
   
2. Control de Acceso (Autenticación)
   1. Permite que recursos como VMs, funciones o contenedores se autentiquen automáticamente con otras APIs de Google Cloud sin usar claves de usuario. GCP maneja la gestión de las claves criptográficas internas por ti.

3. Identidad no Humana
   1. Es una forma segura de darle acceso a una máquina o proceso, en lugar de usar una cuenta de usuario final (humana) que podría tener demasiados permisos o cuya clave podría ser robada.




__Note:__
* Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.



### Cluster
* https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_cluster
* https://registry.terraform.io/providers/hashicorp/google/3.14.0/docs/resources/container_cluster
* 



- Install kubectl cli
- Create Terraform configs for GKE standard public cluster
- Create GKE cluster using Terraform
- Verify resources


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



+ Project
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





## What is terraform backend?

* Backends son los responsables de almacenar y proveer una API para el bloqueo del estado
  * Local Backend
    * Terraform Local State Storage
    * Inside Terraform Local Working Directory
  * Remote Backend
    * Terraform Remote State Storage
    * Google Cloud Storage Buckets

* Terraform __State Storage__: default.tfstate
* Terraform __State Locking__: default.tflock


### Terraform Remote Backend for GCP Terraform Resources

* Terraform Remote Backend as GCP Cloud Storage Bucket
---

backend "gcs" {
    # bucket name que se proveera para almacenar los archivos de estado
    bucket = "terraform-on-gcp-gke"
    # 
    prefix = "dev/gke-cluster-public"
}

---

1. Es necesario crear primero el bucket en la consola de google
2. 