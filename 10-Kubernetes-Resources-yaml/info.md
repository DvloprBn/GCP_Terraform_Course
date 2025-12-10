# 10-Kubernetes-Resources-yaml
* Github Packages: https://github.com/stacksimplify?tab=packages
* https://developer.hashicorp.com/terraform/language/backend
* https://developer.hashicorp.com/terraform/tutorials/kubernetes/gke?in=terraform%2Fkubernetes&utm_source=WEBSITE&utm_medium=WEB_IO&utm_offer=ARTICLE_PAGE&utm_content=DOCS
* https://registry.terraform.io/modules/terraform-google-modules/kubernetes-engine/google/latest
* https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/tree/main/examples
* 

+ eliminar archivos que generan espacio
rm -rf .terraform*
rm -rf terraform.tfstate*

* comando du -sh permite saber cuanto pesa el directorio de donde se esta ejecutando el comando

## Kubernetes YAML Manifests - Demo


* GKE-Kubernetes Load Balancer Service
    + GKE Cluster
      + default namespace
        + MyApp1 Deployment 
          + Pods  <--- ReplicaSet  <--- Deployment
        + User ---> service Port 80 ---> Load Balancer Service  ---> Target Port 80
          + Service Port 80 > Load Balancer Service > Target 80 > Pods  < ReplicaSet  < Deployment



### Create GKE Standard Public Cluster

* en el GKE standard Public los worker nodos tendran acceso a intenet por que se encuentran asociados a la IP Publica de GKE
* Se conectara para obtener la imagen que se descargara en el contenedor

##### GKE Cluster Modes & Types

* GKE Cluster Modes
  1. GKE Standard:
     1. Es necesario tomar decisiones sobre como se gestionaran los contenedores
  
  2. GKE Autopilot: 
     1. No se necesita gestionar los nodos de Kubernetes manualmente 

* GKE Cluster Types
  * GKE Zonal Cluster
    * todos los nodos seran especificos de la zona indicada
  * GKE Regional Cluster
    * Region especifica don de los nodos se distribuiran a travez de diferentes zonas


* Adicionalmente es posible la creacion de:
  1. GKE Public Cluster
    * Cluster mas basico
  2. GKE Private Cluster
    * Cluster mas seguro
  3. GKE Alpha Cluster
  4. GKE Cluster using Windows Node Pools



Estructura:

  1. Project: <projectId> 
     * Customer VPC: <vpcname>  
       + Region: <regionname> 
         + GKE Cluster
           - Subnet
             - Zone: <zonename>
               - GKE Node
                 - Kubelet 
               - Public IP
               - Private IP



Notas: 
  
  * Una misma Region podra trabajar con diferentes zonas, respectivas a esa region
  * 

### Kubernetes Deployment

* Kubectl get deploy
* kubectl get pods
* Kubectl describe pod <PodName>
* kubectl get svc ( obtiene los servicios )

# Delete Kubernetes Resources
* Eliminara todo lo relacionado a Kubernetes
* kubectl delete -f p2-k8sresources-yaml


### Load Balancer Service
* Permite la creacion del Cloud Load Balancing





* Load Balancer Service
        El Balanceador de Carga (Load Balancer) es un servicio de red fundamental en Google Cloud Platform (GCP) que garantiza que tus aplicaciones sean rápidas, estén disponibles de forma continua y puedan manejar grandes cantidades de tráfico.🎯 
        
        ¿Qué es un Balanceador de Carga?
        
        Un Balanceador de Carga es un"componente de red virtual que actúa como un punto de entrada único para todo el tráfico de usuarios dirigido a tu aplicación". 
        
        Su trabajo principal es recibir ese tráfico y distribuirlo de manera inteligente entre un conjunto de servidores o recursos de procesamiento subyacentes (los backends).Piensa en él como un director de orquesta 🎼 o un conserje en un edificio con muchos ascensores. En lugar de que todos los usuarios intenten acceder al mismo servidor, el balanceador los redirige al servidor que tenga menos carga o esté más cerca.⚙️ 
        
        ¿Cómo Funciona un Load Balancer en GCP?
        El funcionamiento en GCP se basa en un conjunto de reglas y componentes que trabajan juntos para lograr la distribución óptima.
        
        1. Componentes ClaveComponenteFunciónFrontend (o Regla de Reenvío)Es la interfaz pública. 
           1. Define la dirección IP (externa o interna) y los puertos donde el balanceador escucha el tráfico de los usuarios.
           
           2. BackendEs el conjunto de recursos que ejecutan tu aplicación, como grupos de instancias de VM, grupos de nodos de GKE, Cloud Run, o Cloud Functions. 
           
           3. El tráfico se envía a estos grupos.
           
           4. Health Checks (Comprobaciones de Salud)Son pings periódicos que el balanceador envía a los backends. Si un servidor no responde a la comprobación de salud, el balanceador lo marca como inactivo y deja de enviarle tráfico, garantizando la tolerancia a fallos.
           
           5. Mapas de URL (solo L7)En los balanceadores de capa 7 (HTTP/S), definen cómo enrutar el tráfico basándose en la URL o ruta (ej. el tráfico a /api va a un grupo de servidores y el tráfico a /images va a otro).
        
        2. Algoritmo de DistribuciónEl balanceador utiliza algoritmos (como Round Robin o mínimas conexiones) para decidir a qué servidor enviar el tráfico.
        3. Escalado AutomáticoEl balanceador de carga está íntimamente ligado a los Grupos de Instancias Administradas (Managed Instance Groups - MIGs). Cuando la carga aumenta, el balanceador detecta el aumento y el MIG automáticamente crea nuevas VMs para manejar el tráfico. Cuando la carga disminuye, las VMs se eliminan para ahorrar costos.
   

        🌐 Tipos Principales de Load Balancer en GCPGCP ofrece varios tipos, clasificados según la Capa OSI en la que operan y su Alcance (Global o Regional).
        
                A. Según la Capa OSITipoCapaProtocolosUso ComúnHTTP(S) / Externo (L7)Capa 7 (Aplicación)HTTP, HTTPS, HTTP/2Ideal para aplicaciones web globales. Puede inspeccionar la URL y usa funciones avanzadas como el caché (Cloud CDN). Es global.TCP/UDP (L4)Capa 4 (Transporte)TCP, UDP, SSLPara aplicaciones que no son web, tráfico de juegos o protocolos personalizados. Es más rápido que el L7, ya que no inspecciona el contenido de la solicitud. Puede ser global o regional.Balanceador de Carga de Red de Paso (Network TCP/UDP Load Balancing)Capa 4 (Transporte)TCP, UDPUn balanceador passthrough (de paso) que reenvía el paquete de red directamente a los backends. Se usa para preservar la IP de origen del cliente. Es regional.
                
                B. Según el AlcanceBalanceador de Carga Global:Distribuye el tráfico a través de múltiples regiones de GCP.Utiliza la red troncal de Google para enrutar el tráfico al backend regional más cercano al usuario, minimizando la latencia.Ejemplo: Balanceador de Carga HTTP(S) Externo.Balanceador de Carga Regional:Distribuye el tráfico solo a los backends dentro de una única región o zona.Ejemplo: Balanceador de Carga TCP/UDP Interno.💡
                
                
        Beneficios de su UsoUtilizar un balanceador de carga no es solo por distribución; es la base para una arquitectura moderna y robusta:
        
        Alta Disponibilidad y Tolerancia a Fallos: Si un servidor o incluso una zona de una región cae, el balanceador redirige automáticamente el tráfico a los servidores sanos restantes.
        
        Escalabilidad: Permite manejar picos de tráfico al escalar horizontalmente (añadiendo más servidores) de forma automática.
        
        Latencia Mínima: Los balanceadores de carga globales envían a los usuarios al centro de datos más cercano geográficamente, mejorando la experiencia del usuario.
        
        Seguridad (WAF): Los Balanceadores de Carga HTTP(S) externos pueden integrarse con Cloud Armor para proporcionar seguridad perimetral (Web Application Firewall).









### Terraform Remote Backend

* Backends are responsible for storing state and providing an API for state locking
  1. Local Backend
     1. Local State Storage
     2. Inside Terraform Local Working Directory
     3. Multiple Team Members cannot update the infraestructure as they don't have access to State File.
     4. Esto significa que se necesita almacenar el state file en una ubicacion compartida
  
  2. Remote Backend 
     1. Remote state Storage
     2. Google Cloud Storage
     3. Remote state File
     4. Using __Terraform Backend concept__ we can use __GCP Cloud storage bucket__ as the __shared storage for state files__
     5. por default esta activado el state locking 

        Note: 
                si 2 integrantes del equipo ejecutan Terraform al mismo tiempo (comandeos ejecutados al mismo tiempo), se encontraran en una carrera de condiciones, ya que multiples procesos de Terraform hacen actualizaciones constantes al archivo de estado y tambien para la infraestructura, lo que termina en conflictos, perdida de datos y corrupcion del archivo de estado.
                Este problema se resolvera utilizando el concepto llamado bloqueo de estado que no permitira el escenario antes mencionado.
                Se solucionara bloqueando las modificaciones al terraform.tfstate


#### Terraform State Storage & Terraform State Locking

  * Terraform State Storage 
    * GCP Cloud Storage Bucket
    * default.tfstate
  
  * Terraform State Locking
    * GCP Cloud Storage Bucket
    * default.tflock
    * al ejecutarse Terraform Plan se realizara la acction del state Locking
    * Por lo que mantendra el estatdo unicamente para el usuario respectivo
    * en caso de que otro usuario pretenda ejecutar Terraform Plan o algun comando, indicada que ya hay un proceso en ejecucion



##### GCP Cloud Storage Bucket

* Backend block:
        backend "gcs" {
                bucket = ""
                prefix = ""
        }




--- 


--- 


- Kubernetes Deployment
- Kubernetes Load Balancer Service








* Default namespace.
* Deploy using Kubectl cli



