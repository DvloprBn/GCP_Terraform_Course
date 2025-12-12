# kubernetes Engine 

## Create GKE Standrad Private Cluster

### GKE Standard Private Cluster with Public Kubernetes API Server Endpoint + Cluster Autoscaler

* __Private Clusters__: 
        Control Plane VPC network is connected to the customer (our) VPC networking using __VPC Networking Peering__ 

        Customer VPC: myvpc  <==> VPC Network Peering <==>  Google Managed VPC Network
                                  Private Connectivity


---


* Our VPC network contains __GKE nodes__        

* Google manage VPC network contains __GKE Cluster Contorl Plane__ 
    * Kube-apiserver
    * kube-scheduler
    * kube-controller-manager


    * El __Control Plan de GKE__ es un __servicio gestionado__ que te permite enfocarte en __la capa de la aplicación__. 
  
    * El Control Plane es la capa de seguridad más importante porque actúa como la única puerta de entrada para manipular el estado del clúster.
    
    * El Control Plane en sí no controla el acceso a Internet de tus Pods (esa es tarea de tu VPC y Cloud NAT). Sin embargo, sí controla el acceso al Control Plane mismo
    
    * El GKE Control Plane es esencialmente el punto de control de seguridad lógica (IAM/RBAC) de tu clúster en cualquier configuración.
      * Tipo de Cluster:
        1. Public: 
           1. Accesible desde Internet (protegido por IAM y Redes Autorizadas).
           2. Los nodos de trabajo sí se comunican de forma privada.
        2. Private: 
           1. Solo accesible desde la VPC del usuario (Máximo Aislamiento de red).
           2. La comunicación entre Control Plane y Nodos de trabajo es completamente privada (VPC Peering).

    * El Control Plane es vital porque garantiza que el negocio de la logística sea resiliente y que el estado deseado de los pedidos (la infraestructura) se mantenga, todo esto con Google gestionando la complejidad detrás de escena.





        El trabajo se centra en:

        Configurar correctamente los Nodos de Trabajo (con suficiente capacidad y las labels correctas).

        Asegurar el endpoint del API Server (privado vs. público).

        Monitorear el rendimiento y la estabilidad del clúster (aunque el Control Plane es gestionado, su rendimiento afecta a tus Pods). 


    * Cerebro del Cluster de kubernetes

        __Note__: El GKE Control Plane es el conjunto de componentes principales que gestiona y mantiene el estado del clúster de Kubernetes. Es responsable de tomar decisiones globales (como la programación de Pods), detectar y responder a eventos, y almacenar el estado de la configuración.
        La diferencia clave en Google Kubernetes Engine (GKE) es que Google gestiona este Plano de Control por ti.

    1. Componentes:
        1. etcd: 
           1. El Almacén de la Verdad. Es una base de datos distribuida de clave-valor que almacena el estado deseado y el estado real de tu clúster (Pods, Deployments, Services, etc.).
           2. No interactúas directamente. Su estabilidad es crítica. Google se encarga de su respaldo, redundancia y alta disponibilidad.
           3. Almacena el estado deseado ("Necesitamos $100$ Pods de Checkout Service activos") y el estado actual ("Hay $98$ Pods activos"). Garantiza que nunca haya dos versiones de la verdad.
        
        2. API Server (kube-apiserver):
           1. La Puerta de Enlace. Es el frontend del Control Plane. Recibe todos los comandos (vía kubectl o Terraform) y es el único componente que habla con etcd.
           2. Tu punto de interacción. Terraform y kubectl envían manifiestos (YAML/HCL) a este server a través de una endpoint (dirección IP).
           3. Recibe todas las instrucciones (un nuevo pedido web, una solicitud de devolución, un cambio de inventario). Es la única interfaz con la que interactúan los clientes (desarrolladores/Terraform).
        
        3. Scheduler (kube-schedule):
           1. l Programador. Monitorea el API Server en busca de nuevos Pods sin nodo asignado y elige el mejor nodo (máquina virtual) para ejecutarlo, basándose en requisitos de recursos, afinidad, etc.
           2. Define la eficiencia. Tus peticiones de recursos (CPU/RAM) en los manifiestos de Pods son leídas por el Scheduler para optimizar la ubicación.
           3. Cuando entra un nuevo pedido (un Pod), el Scheduler decide qué nodo de trabajo está libre y es la más adecuada para procesar ese pedido, basándose en la carga y los recursos disponibles.
        
        4. Controller Manager: 
           1. El Vigilante. Es un conjunto de controladores que observan el estado real del clúster (etcd) y lo comparan continuamente con el estado deseado.
           2. Garantiza la Resiliencia. Por ejemplo, si un nodo falla, el controlador de replicación detecta la discrepancia y ordena al Scheduler crear el Pod faltante en otro nodo.
           3. Monitorea continuamente. Si un nodo de trabajo falla, el Supervisor se da cuenta de que faltan pedidos por procesar, y le pide al Despachador (Scheduler) que reemplace o reasigne la carga en otro lugar.

     2. Implicaciones en GCP y Terraform
        Desde la perspectiva de la infraestructura como código (IaC) y SRE, __la gestión del Control Plane por parte de Google__ tiene varias ventajas y puntos clave:

        A. Costo y Gestión
                Ahorro de Gestión: Google se encarga del patching, las actualizaciones, los respaldos y la alta disponibilidad del Control Plane. Tú no tienes que provisionar VMs ni configurar balanceadores de carga para los componentes del Control Plane.

                Costo: El Control Plane tiene un costo fijo mensual por clúster (a menos que uses la versión Autopilot), independientemente del tamaño de los nodos de trabajo (Node Pools). Esto debe incluirse en tu cálculo de costos de Terraform.

        B. Interacción con Terraform
                Cuando usas Terraform para crear un clúster de GKE (google_container_cluster), la configuración solo define:

                La Configuración del Control Plane: Versión de Kubernetes, habilitación de servicios avanzados (ej. Workload Identity, Logging).

                Los Nodos de Trabajo (Node Pools): Son las máquinas virtuales donde se ejecutarán tus Pods.

                Terraform NUNCA provisiona los componentes del Control Plane (etcd, API Server). Simplemente pide a Google que cree el Control Plane por ti en el backend de GCP.

        C. Seguridad y Redes
                Cluster Privado: Si configuras un clúster privado con Terraform, el Control Plane reside en una VPC gestionada por Google y se comunica con tus nodos de trabajo a través de una conexión privada (VPC Peering). Esto significa que el endpoint de la API (al que te conectas con kubectl) puede ser inaccesible desde Internet público, aumentando la seguridad.




  * Los Nodos de Trabajo (Worker Nodes)
        En GKE: Son las VMs (máquinas virtuales) donde se ejecutan tus microservicios (Pods).
  * La Seguridad (Clúster Público vs. Privado)
  
    - Clúster Público (Acceso Abierto): Es como si la Mesa de Recepción de Órdenes (API Server) estuviera en la calle con acceso desde cualquier parte del mundo. Solo confías en que los guardias de seguridad (IAM/Autenticación) revisen la identificación de cualquiera que intente dar una orden.

    - Clúster Privado (Máxima Seguridad): Es como si la Mesa de Recepción estuviera en un cuarto cerrado con acceso biométrico. Solo puedes acceder a la mesa y dar órdenes desde la red interna (tu propia oficina, tu VPC).


---

* Traffic between nodes and control plane is routed using internal IP addresses only


---


* Los clusters se pueden crear y configurar en dos modos
  * Standard
  * Autopilot

* Private clusters tendran nodos que no tendran dicrecciones IP externas.

* para proveer acceso a internet desde un nodo privado especifico es necesario usar:
  * Cloud NAT
  * Cloud Router




* Accesing using kubectl
    + Laste Securo Option 
      1. Public endpoint access: Enabled
      2. Authorized Networks: Disabled
      3. Accessible via Internet

    + Medium Secure Option: 
      1. Public endpoint access: Enabled
      2. Authorized Network: Enabled
      3. Accessible via authorized internet IP ranges 
         1. (Example: Cloudshell, local desktop, from specified network in authorized network)

+ High secure option:
  1. Public endpoint access: disabled
  2. accessible via:
     1. __VM__ in google VPC network
     2. __On-premise network__ provider cloud VPN or Cloud interconnect is configured




kubernetes clustes Autoscaler

* cluster Autoscaler:
  * Automatically resizes the number of nodes in a node pool, based on the demands of your workloads.
  * Min: 3      # puede inicar en 1
  * Max: 12     # puede ser 13, 14, 15, ...
* Scale Out: Gradually increses nodes to maximum size based on need (When pods are unschedulable)
* scale In: Decreses Nodes to minimum size when nodes are idle (no wokloads scheduled on them.)

* Benefits:
  * Increses the availability of your workloads.
  * Control the cost.
  * Effective use of system resources (CPU, Memory)

Standard VS Autoscaler CLusters

* Standard cluster uses Cluster Autoscaler
* Autopilot uses Node auto-prosisioning
  * GKE automatially takes care of the node pools.




* 


********************************************************************


Practice: 


* Create Terraform configs for GKE standard private cluster
* Configure Cluster Autoscaler (Nodepool autosclaing)
* Execute Terraform Commands to GKE standard private cluster
* Verify resources

Execute Terraform Commands

        # Change Directory
        cd p1-gke-private-cluster-autoscaler

        # Terraform Initialize
        terraform init

        # Terraform Validate
        terraform validate

        # Terraform plan
        terraform plan

        # Terraform Apply
        terraform apply -auto-approve



Verify GKE private cluster resources        


        # Verify GCP GKE Resources
        1. GKE cluster
        2. GKE Node pools

        # Configure kubectl cli
        gcloud container clusters get-credentials CLUSTER_NAME --region REGION --project PROJECT_ID
        gcloud container clusters get-credentials hr-dev-gke-cluster --region us-central1 --project gcplearn9

        # kubectl version client and server(cluster)
        kubectl version 

        # List Kubernetes Nodes
        kubectl get nodes -o wide
        Observation: 
        3. Only private IPs will be associated with the GKE Nodes



Deploy Sample Application and Verify    

        # Change Directory
        cd p3-k8sresources-terraform-manifests

        # Update c1-versions.tf
        backend "gcs" {
        bucket = "terraform-on-gcp-gke"
        prefix = "dev/k8s-demo1"    
        }  

        # Update c3-01-remote-state-datasource.tf
        # Terraform Remote State Datasource
        data "terraform_remote_state" "gke" {
        backend = "gcs"
        config = {
        bucket = "terraform-on-gcp-gke"
        prefix = "dev/gke-cluster-public"
        }  
        }  

        # Terraform Initialize
        terraform init

        # Terraform Validate
        terraform validate

        # Terraform plan
        terraform plan

        # Terraform Apply
        terraform apply -auto-approve


Verify Kubernetes Resources

        # List Nodes
        kubectl get nodes -o wide

        # List Pods
        kubectl get pods -o wide
        Observation: 
        1. Pods should be deployed on the GKE node pool

        # List Services
        kubectl get svc
        kubectl get svc -o wide
        Observation:
        1. We should see Load Balancer Service created


        # Access Sample Application on Browser
        http://<LOAD-BALANCER-IP>        




Verify Kubernetes Resources via GCP console

        Go to Services -> GCP -> Load Balancing -> Load Balancers
        Verify Tabs
        Description: Make a note of LB DNS Name
        Instances
        Health Checks
        Listeners
        Monitoring




Test Cluster Autoscaler

        # List Kubernetes Pods
        kubectl get pods -o wide

        # List Kubernetes Nodes
        kubectl get nodes

        # List Kubernetes Deployments
        kubectl get deploy

        # Scale the Deployment
        kubectl scale deployment myapp1-deployment --replicas=100

        # List Kubernetes Pods
        kubectl get pods
        Observation: 
        1. Few Pods will be in pending state

        # List Nodes
        kubectl get nodes
        Observation:
        1. Nodes will be autoscaled
        2. new nodes will be created.


Clean-Up

        # Delete Kubernetes  Resources
        cd p3-k8sresources-terraform-manifests
        terraform apply -destroy -auto-approve
        rm -rf .terraform* 

        # Delete GCP GKE Cluster (DONT DELETE NOW)
        cd 12-GKE-Private-Standard-Cluster/p1-gke-private-cluster-autoscaler/
        terraform apply -destroy -auto-approve
        rm -rf .terraform* 