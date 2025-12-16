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






***



# Practica 13


* 
* Horizontal Pod Autoscaler
  * DEMO: GKE Horizontal Autoscaler




El Horizontal Pod Autoscaler (HPA) de Kubernetes es un controlador que ajusta automáticamente el número de réplicas de Pods en un Deployment, ReplicaSet o StatefulSet en función de la carga de trabajo observada, como la utilización de CPU o métricas personalizadas.


El HPA opera en un bucle de control continuo:

Monitorización de Métricas: El HPA consulta periódicamente las métricas de uso de los Pods objetivo (por defecto, cada 15-30 segundos). Las métricas más comunes son:

Uso de CPU: Expresado como un porcentaje de los recursos solicitados por el Pod.

Uso de Memoria: Similar al CPU.

Métricas Personalizadas y Externas: Como el número de solicitudes por segundo (QPS) o métricas de Google Cloud Monitoring (en GKE).

Cálculo de Réplicas Deseadas: El HPA compara el valor promedio de la métrica observada con el umbral objetivo que tú has definido. Luego, utiliza un algoritmo para calcular el número de réplicas necesarias para alcanzar ese objetivo.

Fórmula Básica (para CPU/Memoria):
$$Réplicas\ Deseadas = \lceil \frac{Uso\ Actual\ Promedio}{Umbral\ Objetivo} \times Réplicas\ Actuales \rceil$$

Si se configuran múltiples métricas, el HPA evalúa cada una por separado y elige la escala más grande (el mayor número de réplicas deseadas) para asegurar que ninguna métrica exceda su umbral.

Ajuste de Escala (Scaling):
    
    Scale Out (Aumentar): Si la utilización actual es significativamente mayor que el objetivo, el HPA aumenta el número de réplicas hasta el maxReplicas configurado.
    
    Scale In (Reducir): Si la utilización actual es significativamente menor que el objetivo y ha permanecido así durante un período de estabilización (por defecto, 5 minutos), el HPA reduce el número de réplicas hasta el minReplicas configurado.



Diferencia Clave con Cluster Autoscaler
Es importante notar que el HPA solo escala los Pods dentro de los nodos existentes. Si el scale out del HPA resulta en Pods que no pueden ser programados por falta de recursos en el nodo, entra en juego el Cluster Autoscaler (otro componente de GKE) para añadir nuevos nodos al clúster para que los Pods puedan ser alojados.


***

