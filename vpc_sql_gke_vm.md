# Definicion Terraform VPC, GKE, VM & Psql

#### Resoruces
  * google_compute_network
  * google_compute_subnetwork
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








-- 


Conectividad Interna
Una vez creados, el funcionamiento de la conectividad se garantiza porque todos los componentes de la aplicación (GKE y VM) residen en la misma VPC, y tienen una ruta privada para comunicarse con la base de datos PSQL (Cloud SQL) a través del VPC Peering.