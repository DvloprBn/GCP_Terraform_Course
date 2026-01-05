# Create GKE Autopilot Private cluster with k8s API Server Public endpoint

* GCP Google Kubernetes Engine GKE - Autopilot Private Cluster

* Learn to deploy GCP GKE Autopilot private cluster using Terraform



Create Terraform configs for GKE Autopilot cluster
Deploy and Verify cluster resources
Deploy sample application and test



---



* Este es uno de los temas más avanzados y "seguros" para desplegar aplicaciones en Google Cloud. 


¿Qué es un GKE Autopilot Private Cluster?
Imagina que tienes la "Orquesta" (el Cluster), pero con dos condiciones especiales:

Autopilot (El "Piloto Automático"): Tú no te encargas de los músicos (nodos). Google crea, escala, asegura y repara las máquinas por ti. Tú solo entregas la partitura (tus contenedores) y Google se encarga de que suenen bien. Pagas por lo que consumen tus Pods, no por la máquina completa.

Private (Privado): Los músicos están encerrados en una habitación sin ventanas al exterior. Esto significa que los Nodos del cluster no tienen direcciones IP públicas. Solo pueden hablar con otros recursos dentro de tu VPC o a través de una VPN/Interconnect.

¿En qué consiste exactamente?
Un cluster privado de Autopilot se basa en tres pilares de red:

Aislamiento de Nodos: Como no tienen IP pública, son inmunes a ataques directos desde internet.

Control Plane con acceso restringido: El "Director de la orquesta" (el API Server) vive en una red administrada por Google, pero se conecta a tu VPC mediante un VPC Network Peering. Puedes decidir si quieres que ese Director sea accesible desde internet (con seguridad extra) o que sea 100% privado.

Salida a Internet controlada: Si tus contenedores necesitan descargar algo de internet (como una librería o actualización), no pueden hacerlo directamente. Necesitas configurar un Cloud NAT en tu VPC para que actúe como una "salida de emergencia" controlada.




## Standard vs. Autopilot Privado

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