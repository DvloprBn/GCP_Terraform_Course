# Kubernetes Horizontal Pod Autoscaling

* Automatically increase or decrease number of pods in respons to:
    * Workloads CPU and Memory Utilization
    * Custom metrics reported from within kubernetes Cluster 
    * External metrics (Load Balancers, messaging Services, ...)
    * Custom metrics using Managed Service for Prometheus

* HPA automatically scales the pods in workloads types:
    * Kubernetes RecplicaSet
    * Kubernetes Replication Controller
    * Kubernetes Deployment
    * Kubernetes SatefulSet


* This can help our applications
    * __Scale out__ to meet increased demand or
    * __Scale in__ when resources are not needed, thus freeing up your worker nodes for other applications


* HPA Imperative ffCommand : Kubectl autoscale deployment my-app --max 6 --min 4 --cpu-percent 50


## Kubernetes Metrics Server


* Metric Server collects resource metrics from __kubelets and exposes themin kubernetes apiserver__ through __Metrics API__

* Metrics API can also be accessed by __kubectl top__, making it easier to debug autoscaling pipelines.

* Fast Autoscaling solution, __collecting metrics every 15 seconds__.
Metric Server is not mean for __non-autoscaling purposes__. For example, don'y use it to forward metrics to monitoring solutiuons.

* Resource efficiency, __using 1 mili core if CPU and 2 MB of memory__ for each node in a cluster.

* Metric Server used for __CPU/Memory__ based __horizontal autoscaling__.

* Metric Server used for automatically adjusting/ suggesting resources needed by containers (__Vertical Autoscaling__)  













# Ben





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

1. Fundamentos del HPA en GKE
   1. El __HPA es un controlador del plano de control de Kubernetes__ que ajusta automáticamente el número de réplicas __de un Deployment, ReplicaSet o StatefulSet__ para igualar la demanda de carga.
   2. El Bucle de Control:
      1. El controlador HPA opera en un ciclo continuo, revisando periódicamente (cada 15 segundos por defecto):
      2. Obtener Métricas: Consulta el Metrics Server (o fuentes externas) para obtener las métricas de uso de los Pods objetivo.
      3. Calcular Réplicas: Compara el valor actual promedio de la métrica con el objetivo (target) que tú definiste.
         1. Fórmula del Algoritmo: 
            
            1. Réplicas Deseadas = ( ( Métrica Actual Promedio/Umbral Objetivo ) * Réplicas Actuales )
      
      4. Aplicar Escala: Si el resultado del cálculo está fuera del rango de tolerancia del 10% (configurable en versiones recientes de Kubernetes), envía un comando al Deployment o StatefulSet para ajustar el número de réplicas.
   3. Requisito Crítico: Resource Requests
      1. Para que __el HPA funcione correctamente con métricas de CPU y Memoria__ (basadas en porcentaje), es obligatorio que __el Pod defina resources.requests para esos recursos__.
      2. Si estableces un objetivo de CPU del 50%, el HPA lo interpreta como: 
         1. "Mantener el uso promedio de CPU de los Pods al 50% de lo que cada Pod solicitó (request)."


2. Tipos de Métricas y Fuentes en GKE
   1. Una de las grandes fortalezas del HPA es su capacidad para escalar basándose en múltiples tipos de métricas.
   2. Métricas Basadas en Recursos (Resource Metrics)
      1. Son las más comunes y se basan en el uso directo de CPU y Memoria de los Pods.
      2. Métrica
         1. CPU
         2. Memoria
      3. Tipo
         1. CPU     - averageUtilization (Porcentaje)
         2. Memoria - averageUtilization (Porcentaje)
      4. Target
         1. ej: 60
         2. ej: 75
      5. Origen en GKE
         1. CPU     - Metric Server
         2. Memoria - Metric Server
   3. Métricas Personalizadas (Custom Metrics)
      1. Son métricas específicas de la aplicación, reportadas desde dentro del clúster.
      2. Ejemplo: Escalar basándose en el número de mensajes en una cola interna.
      3. Implementación en GKE: Generalmente se utiliza el Servicio Administrado para Prometheus de Google Cloud (anteriormente Stackdriver).
      4. Expones las métricas con un Prometheus Exporter y el adaptador de Prometheus las hace accesibles al HPA. 
   4. Métricas Externas (External Metrics)
       1. Son métricas que provienen de servicios de Google Cloud o sistemas completamente externos al clúster de Kubernetes, que no están directamente asociadas con los Pods escalados.
       2. Ejemplo: Escalar basándose en:
         1. Tamaño de la cola de Pub/Sub: Si la cola crece por encima de 1000 mensajes pendientes, aumenta los Pods de procesamiento.
         2. Latencia de un balanceador de carga (L7) de GCP.
       3. Implementación en GKE: Se utiliza el Stackdriver Adapter (o el nuevo con Prometheus) para tomar métricas de Cloud Monitoring y exponerlas al HPA.
   5. Importante: Cuando se usan múltiples métricas (Recurso + Personalizada/Externa), el HPA calcula el número de réplicas deseado para cada métrica y siempre elige el número más grande (Scale Out máximo) para garantizar que la carga se maneje.

3. HPA vs. Otros Escaladores de GKE
   1. Es fundamental entender que el HPA es solo una capa en el ecosistema de escalado de GKE.
   2. Mecanismo de Escalado
      1. HPA (Horizontal Pod Autoscaler)
      2. VPA (Vertical Pod Autoscaler)
      3. Cluster Autoscaler (CA)
   3. Objeto que Escala
      1. HPA: Pods (Réplicas de la app)
      2. VPA: Recursos del Pod (CPU/Memoria)
      3. CA: Nodos (Máquinas VM)
   4. ¿En qué se basa?
      1. HPA: Uso de CPU/Memoria, Métricas Personalizadas/Externas.
      2. VPA: Uso histórico/actual de recursos.
      3. CA: Hay Pods pendientes de ser programados (No hay recursos en los nodos).
   5. Propósito
      1. HPA: Manejar el tráfico de la aplicación y la carga de trabajo.
      2. VPA: Optimizar las requests y limits del Pod para aumentar la eficiencia (No se recomienda usar VPA y HPA en la misma métrica de recursos).
      3. CA: Ajustar la infraestructura de GKE a la demanda del Pod.
   
---    

4. Flujo de Escalado Completo en GKE:
   
   1. El tráfico aumenta.
   2. El uso de CPU de los Pods supera el 60% (Target del HPA).
   3. HPA ordena crear 5 Pods más (Scale Out).
   4. El Scheduler de Kubernetes no encuentra espacio para 3 de los nuevos Pods --> Pasan a estado Pending.
   5. El Cluster Autoscaler detecta los Pods pendientes y provisiona un nuevo nodo VM.
   6. Los Pods pendientes se programan en el nuevo nodo --> El sistema está escalado de forma segura y rentable.


---

5. Comportamiento y Estabilización (Configurable Scaling)
   1. El HPA tiene mecanismos internos para prevenir el "Thrashing" (escalado repetitivo e inestable, sube-baja-sube-baja).
      1. Tolerancia: Por defecto, el HPA solo actúa si la métrica promedio excede la meta en más del 10% (configurable en Kubernetes 1.33+).
      2. Tiempo de Estabilización (Stabilization Window):
         1. Scale Down (Reducción): Después de un evento de Scale Out, el HPA debe esperar un período de tiempo (Scale Down Stabilization Window, 5 minutos por defecto) antes de poder reducir las réplicas.Esto evita que una caída temporal de la carga (o un pico muy corto) haga que el HPA reduzca los Pods inmediatamente después de haberlos creado.
         2. Scale Up (Aumento): Después de un evento de Scale Up, el HPA debe esperar un tiempo más corto (casi instantáneo) para volver a escalar hacia arriba si la métrica sigue alta.
   2. Puedes ajustar estos tiempos en la sección spec.behavior del objeto HPA para optimizar la respuesta a tus patrones de tráfico.







# Kubelet: 
  * el Kubelet es el componente más importante que corre dentro de cada nodo.
  
  * Si comparamos un clúster de Kubernetes con una flota de barcos, el Control Plane (el cerebro en Google) sería el Almirante, y el Kubelet sería el Capitán de cada barco (nodo). Su misión es recibir órdenes y asegurarse de que el trabajo se haga exactamente como se pidió.
  
  * El Kubelet es un "agente de nodo" que se ejecuta en todos y cada uno de los nodos del clúster. 
  
  * Es el punto de contacto principal entre el Plano de Control (administrado por Google en GKE) y los Nodos de Trabajo (las máquinas virtuales de Compute Engine).

    funciones principales:
      1. Ejecución de Pods: El Kubelet no crea los contenedores por sí mismo, sino que le da instrucciones al Container Runtime (como containerd) para que los inicie basándose en el PodSpec (un archivo YAML/JSON que describe el pod).
      2. Reporte de Estado: Constantemente informa al API Server sobre la salud del nodo y de los Pods que tiene a su cargo. Si un Pod falla, el Kubelet lo nota y lo reporta.
      3. Liveness y Readiness Probes: Es el encargado de ejecutar las pruebas de salud que tú defines. Él "toca la puerta" de tu aplicación para ver si sigue viva o si ya puede recibir tráfico.
      4. Gestión de Recursos: Asegura que los contenedores no consuman más CPU o Memoria de la que tienen permitida (basado en los limits y requests).

    1. Nodos como Instancias de Compute Engine
        En GKE, cada nodo es una VM de Google Compute Engine. El Kubelet viene preinstalado en la imagen de SO optimizada para contenedores (COS) que Google proporciona. Tú no tienes que instalarlo manualmente, GKE lo hace por ti al crear el clúster.

    2. Actualizaciones Gestionadas
        Una de las grandes ventajas de GKE es el Auto-upgrade. Cuando Google decide actualizar la versión de Kubernetes, lo que hace es actualizar el Kubelet de tus nodos de forma progresiva. Terraform facilita esto permitiéndote definir la versión del clúster y de los nodos.

    3. Autenticación y Registro
        El Kubelet en GKE utiliza las cuentas de servicio de Google Cloud para autenticarse con el API Server. También facilita la integración con Cloud Logging y Cloud Monitoring, enviando los logs de los contenedores y las métricas de uso de recursos directamente a la consola de GCP.


    Flujo de Trabajo:
        - Observa: Mira el API Server de GKE para ver si hay nuevos Pods asignados a su nodo.

        - Actúa: Si hay un Pod nuevo, descarga las imágenes de Artifact Registry (o Docker Hub) y le pide al runtime que levante los contenedores.

        - Verifica: Revisa que los contenedores estén corriendo.

        - Informa: Envía un mensaje de vuelta a Google diciendo: "Todo listo, el Pod 'mi-app' está activo en el nodo X".






---


### Verify Kubernetes Resources


# List Pods
kubectl get pods
Observation: 
1. Currently only 1 pod is running

# List HPA
kubectl get hpa

# Run Load Test (New Terminal)
kubectl run -i --tty load-generator --rm --image=busybox --restart=Never -- /bin/sh -c "while sleep 0.01; do wget -q -O- http://myapp1-cip-service; done"

# List Pods (SCALE UP EVENT)
kubectl get pods
Observation:
1. New pods will be created to reduce the CPU spikes

# kubectl top command
kubectl top pod

# List HPA (after few mins - approx 3 to 5 mins)
kubectl get hpa --watch

# List Pods (SCALE IN EVENT)
kubectl get pods
Observation:
1. Only 1 pod should be running when there is no load on the workloads


* Clean-Up
# Delete Load Generator Pod which is in Error State
kubectl delete pod load-generator

# Change Directory
cd p4-k8sresources-terraform-manifests

# Terraform Destroy
terraform apply -destroy -auto-approve

---

Notas: 
   1. La unidad original de la métrica es ms (milisegundos). (250m = 250 milisegundos).
   2.     __Sin el Kubelet, el clúster no tendría pies ni manos. Es el encargado de convertir tus archivos de configuración en contenedores reales corriendo en la infraestructura de Google__.