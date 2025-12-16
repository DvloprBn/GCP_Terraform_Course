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








El HPA es el mecanismo de escalado a nivel de aplicación más fundamental y poderoso en GKE.

1. Fundamentos del HPA en GKEEl HPA es un controlador del plano de control de Kubernetes que ajusta automáticamente el número de réplicas de un Deployment, ReplicaSet o StatefulSet para igualar la demanda de carga.2El Bucle de ControlEl controlador HPA opera en un ciclo continuo, revisando periódicamente (cada 15 segundos por defecto):3Obtener Métricas: Consulta el Metrics Server (o fuentes externas) para obtener las métricas de uso de los Pods objetivo.Calcular Réplicas: Compara el valor actual promedio de la métrica con el objetivo (target) que tú definiste.4Fórmula del Algoritmo:$$Réplicas\ Deseadas = \lceil \frac{Métrica\ Actual\ Promedio}{Umbral\ Objetivo} \times Réplicas\ Actuales \rceil$$Aplicar Escala: Si el resultado del cálculo está fuera del rango de tolerancia del 10% (configurable en versiones recientes de Kubernetes), envía un comando al Deployment o StatefulSet para ajustar el número de réplicas.Requisito Crítico: Resource RequestsPara que el HPA funcione correctamente con métricas de CPU y Memoria (basadas en porcentaje), es obligatorio que el Pod defina resources.requests para esos recursos.Si estableces un objetivo de CPU del 50%, el HPA lo interpreta como: "Mantener el uso promedio de CPU de los Pods al 50% de lo que cada Pod solicitó (request)."⚙️ 2. Tipos de Métricas y Fuentes en GKEUna de las grandes fortalezas del HPA es su capacidad para escalar basándose en múltiples tipos de métricas.5A. Métricas Basadas en Recursos (Resource Metrics)Son las más comunes y se basan en el uso directo de CPU y Memoria de los Pods.MétricaTipoTargetOrigen en GKECPUaverageUtilization (Porcentaje)Ejemplo: 60Metrics ServerMemoriaaverageUtilization (Porcentaje)Ejemplo: 75Metrics ServerB. Métricas Personalizadas (Custom Metrics)Son métricas específicas de la aplicación, reportadas desde dentro del clúster.6Ejemplo: Escalar basándose en el número de mensajes en una cola interna.7Implementación en GKE: Generalmente se utiliza el Servicio Administrado para Prometheus de Google Cloud (anteriormente Stackdriver).8 Expones las métricas con un Prometheus Exporter y el adaptador de Prometheus las hace accesibles al HPA.9C. Métricas Externas (External Metrics)Son métricas que provienen de servicios de Google Cloud o sistemas completamente externos al clúster de Kubernetes, que no están directamente asociadas con los Pods escalados.10Ejemplo: Escalar basándose en:Tamaño de la cola de Pub/Sub: Si la cola crece por encima de 1000 mensajes pendientes, aumenta los Pods de procesamiento.Latencia de un balanceador de carga (L7) de GCP.Implementación en GKE: Se utiliza el Stackdriver Adapter (o el nuevo con Prometheus) para tomar métricas de Cloud Monitoring y exponerlas al HPA.11Importante: Cuando se usan múltiples métricas (Recurso + Personalizada/Externa), el HPA calcula el número de réplicas deseado para cada métrica y siempre elige el número más grande (Scale Out máximo) para garantizar que la carga se maneje.⚖️ 3. HPA vs. Otros Escaladores de GKEEs fundamental entender que el HPA es solo una capa en el ecosistema de escalado de GKE.Mecanismo de EscaladoObjeto que Escala¿En qué se basa?PropósitoHPA (Horizontal Pod Autoscaler)Pods (Réplicas de la app)Uso de CPU/Memoria, Métricas Personalizadas/Externas.Manejar el tráfico de la aplicación y la carga de trabajo.VPA (Vertical Pod Autoscaler)Recursos del Pod (CPU/Memoria)Uso histórico/actual de recursos.Optimizar las requests y limits del Pod para aumentar la eficiencia (No se recomienda usar VPA y HPA en la misma métrica de recursos).Cluster Autoscaler (CA)Nodos (Máquinas VM)Hay Pods pendientes de ser programados (No hay recursos en los nodos).Ajustar la infraestructura de GKE a la demanda del Pod.12Flujo de Escalado Completo en GKE:El tráfico aumenta.El uso de CPU de los Pods supera el 60% (Target del HPA).HPA ordena crear 5 Pods más (Scale Out).El Scheduler de Kubernetes no encuentra espacio para 3 de los nuevos Pods $\rightarrow$ Pasan a estado Pending.El Cluster Autoscaler detecta los Pods pendientes y provisiona un nuevo nodo VM.13Los Pods pendientes se programan en el nuevo nodo $\rightarrow$ El sistema está escalado de forma segura y rentable.🛡️ 4. Comportamiento y Estabilización (Configurable Scaling)El HPA tiene mecanismos internos para prevenir el "Thrashing" (escalado repetitivo e inestable, sube-baja-sube-baja).14Tolerancia: Por defecto, el HPA solo actúa si la métrica promedio excede la meta en más del 10% (configurable en Kubernetes 1.33+).Tiempo de Estabilización (Stabilization Window):Scale Down (Reducción): Después de un evento de Scale Out, el HPA debe esperar un período de tiempo (Scale Down Stabilization Window, 5 minutos por defecto) antes de poder reducir las réplicas.15 Esto evita que una caída temporal de la carga (o un pico muy corto) haga que el HPA reduzca los Pods inmediatamente después de haberlos creado.16Scale Up (Aumento): Después de un evento de Scale Up, el HPA debe esperar un tiempo más corto (casi instantáneo) para volver a escalar hacia arriba si la métrica sigue alta.Puedes ajustar estos tiempos en la sección spec.behavior del objeto HPA para optimizar la respuesta a tus patrones de tráfico.


***

