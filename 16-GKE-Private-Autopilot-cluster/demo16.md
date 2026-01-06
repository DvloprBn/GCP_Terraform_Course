# Create GKE Autopilot Private cluster with k8s API Server Public endpoint

* GCP Google Kubernetes Engine GKE - Autopilot Private Cluster

* Learn to deploy GCP GKE Autopilot private cluster using Terraform



Create Terraform configs for GKE Autopilot cluster
Deploy and Verify cluster resources
Deploy sample application and test



---



* Este es uno de los temas más avanzados y "seguros" para desplegar aplicaciones en Google Cloud. 


¿Qué es un GKE Autopilot Private Cluster?

* Un GKE Autopilot Private Cluster __es un clúster de Google Kubernetes Engine que combina la gestión automática de infraestructura de Autopilot con el aislamiento de red de un clúster privado__.

* GKE Autopilot es un modo de operación en GKE en el que Google administra la configuración de tu infraestructura, incluyendo tus nodos, escalabilidad, seguridad y otras opciones preconfiguradas.

* Lo que significa que Google administra los nodos y el escalado, mientras que los nodos y pods solo tienen direcciones IP internas, aislados de Internet por defecto, 

* y el acceso al plano de control también se puede configurar para ser privado, ofreciendo seguridad y eficiencia sin la sobrecarga de administrar la infraestructura subyacente. 

* Los nodos y Pods solo tienen direcciones IP internas, sin exposición directa a Internet.

* Aislamiento de red por defecto para mayor seguridad.

* Permite configurar el acceso al plano de control (API de Kubernetes) para ser privado, limitado o sin restricciones, según tus necesidades de seguridad.

* También puedes ejecutar cargas de trabajo específicas en modo Autopilot en clústeres de GKE Estándar. Esta opción te permite usar Autopilot en entornos donde aún necesitas control manual sobre tu infraestructura. 



## Clústeres y cargas de trabajo de piloto automático

GKE te permite usar el modo Autopilot para clústeres completos o para cargas de trabajo específicas en tus clústeres estándar. Los clústeres Autopilot son la forma recomendada de usar GKE, ya que todo el clúster utiliza las prácticas recomendadas de Google de forma predeterminada.

Sin embargo, algunas organizaciones requieren control manual o flexibilidad, lo que implica el uso de un clúster estándar de GKE. En estos casos, puede usar Autopilot para cargas de trabajo específicas en sus clústeres estándar, lo que le permite beneficiarse de muchas funciones de Autopilot a nivel de carga de trabajo.


Beneficios de la Combinación:

    * Seguridad Reforzada: Aislamiento de red inherente, protegiendo tus cargas de trabajo de accesos no deseados desde Internet.
    * Operación Simplificada: Autopilot se encarga de la infraestructura de nodos, reduciendo la carga operativa.
    * Optimización de Costos y Recursos: Paga por el uso de Pods y evita la gestión manual de capacidad.
    * Prácticas Recomendadas Integradas: Sigue automáticamente las mejores prácticas de seguridad y configuración de Google.












--- 


#### Analogia

Imagina que tienes la "Orquesta" (el Cluster), pero con dos condiciones especiales:

Autopilot (El "Piloto Automático"): Tú no te encargas de los músicos (nodos). Google crea, escala, asegura y repara las máquinas por ti. Tú solo entregas la partitura (tus contenedores) y Google se encarga de que suenen bien. Pagas por lo que consumen tus Pods, no por la máquina completa.

Private (Privado): Los músicos están encerrados en una habitación sin ventanas al exterior. Esto significa que los Nodos del cluster no tienen direcciones IP públicas. Solo pueden hablar con otros recursos dentro de tu VPC o a través de una VPN/Interconnect.

¿En qué consiste exactamente?
Un cluster privado de Autopilot se basa en tres pilares de red:

Aislamiento de Nodos: Como no tienen IP pública, son inmunes a ataques directos desde internet.

Control Plane con acceso restringido: El "Director de la orquesta" (el API Server) vive en una red administrada por Google, pero se conecta a tu VPC mediante un VPC Network Peering. Puedes decidir si quieres que ese Director sea accesible desde internet (con seguridad extra) o que sea 100% privado.

Salida a Internet controlada: Si tus contenedores necesitan descargar algo de internet (como una librería o actualización), no pueden hacerlo directamente. Necesitas configurar un Cloud NAT en tu VPC para que actúe como una "salida de emergencia" controlada.


* https://docs.cloud.google.com/kubernetes-engine/docs/concepts/autopilot-overview
* https://docs.cloud.google.com/kubernetes-engine/docs/resources/autopilot-standard-feature-comparison
* https://docs.cloud.google.com/kubernetes-engine/docs/how-to/creating-an-autopilot-cluster










---




Benefits

* Focus on your apps: Google manages the infrastructure, so you can focus on building and deploying your applications.

* Security: Autopilot clusters have a default hardened configuration, with many security settings enabled by default. GKE automatically applies security patches to your nodes when available, adhering to any maintenance schedules you configured.

* Pricing: the Autopilot pricing model simplifies billing forecasts and attribution.

* Node management: Google manages worker nodes, so you don't need to create new nodes to accommodate your workloads or configure automatic upgrades and repairs.

* Scaling: when your workloads experience high load and you add more Pods to accommodate the traffic, such as with Kubernetes Horizontal Pod Autoscaling, GKE automatically provisions new nodes for those Pods, and automatically expands the resources in your existing nodes based on need.

* Scheduling: Autopilot manages Pod bin-packing for you, so you don't have to think about how many Pods are running on each node. You can further control Pod placement by using Kubernetes mechanisms such as affinity and Pod spread topology.

* Resource management: if you deploy workloads without setting resource values such as CPU and memory, Autopilot automatically sets pre-configured default values and modifies your resource requests at the workload level.

* Networking: Autopilot enables some networking security features by default, such as passing all Pod network traffic through your Virtual Private Cloud firewall rules, even if the traffic is going to other Pods in the cluster.

* Release management: all Autopilot clusters are enrolled in a GKE release channel so that your control plane and nodes run on the latest qualified versions in that channel.

* Managed flexibility: if your workloads have specific hardware or resource requirements, such as GPUs, you can define those requirements in ComputeClasses. When you request a ComputeClass in your workload, GKE uses your requirements to configure nodes for your Pods. You don't need to manually configure hardware for nodes or for individual workloads.

* Reduced operational complexity: Autopilot reduces platform administration overhead by removing the need to continuously monitor nodes, scaling, and scheduling operations.


---


Note:
    Once the Autopilot cluster is created, if we don't deploy any workloads, after sometimes __Numer of Nodes__, __TotalvCPUs and Total Memory__ all will come to zero.

## Standard vs. Autopilot Privado

Autopilot mode
* Optimized kubeernetes cluster with a hands-off experience.

Standard mode
* Kubernetes cluster with node configuration flexibility.




* Característica,
    * GKE Standard,
    * GKE Autopilot Privado

* Gestión de Nodos,
  * GKE Standard,
    * Tú eliges el tamaño y cantidad.,
  * GKE Autopilot Privado
    * Google lo hace por ti.

* IPs de los Nodos,
  * GKE Standard,
    * Suelen tener IPs públicas (si no es privado).,
  * GKE Autopilot Privado
    * Nunca tienen IPs públicas.

* Costo,
  * GKE Standard,
    * Pagas por la VM (esté vacía o llena).,
  * GKE Autopilot Privado
    * Pagas solo por el CPU/RAM del Pod.

* Seguridad,
  * GKE Standard,
    * Tú configuras los parches del OS.,
  * GKE Autopilot Privado
    * Google mantiene todo actualizado y seguro.