# Google Kubernetes Engine

## Create GKE Standard Private Clsuter with k8s API Srever Private Endpoint

* GKE Standard Private Clsuer with Private Kubernetes API Server Endpoint.


* Last Secure Option
    * Public endpoint access: __Enabled__
    * Authorized NEtworks: __Disabled__
    * Accesible via __Internet__

Usando  __kubectl__    sera posible acceder al __GKE Cluster__ via internet.



* Medium Secure Option.
    * Public endpoint access: __Enabled__
    * Authorized Networks: __Enabled__
    * Accesible via __authorized Internet IPranges__ (Example: CloudShell, local desktop, from specified network in authorized network) 




* High Secure option:
    * Public endpoint access: __Disabled__
    * Accesible via
        * __VM__ in google cloud VPC network
        * __On-Premise network__ provided Cloud VPN or Cloud Interconnect is configured.

    1. Cloud VPC Network (Virtual Private Cloud)
        Es tu espacio de red privado y aislado dentro de la nube pública (como Google Cloud o AWS).

        Función: Es donde defines tus propias subredes, rangos de direcciones IP, reglas de firewall y tablas de enrutamiento.

        Analogía: Es como tener una oficina privada dentro de un gran edificio corporativo (la nube). Nadie puede entrar a tu oficina a menos que tú lo permitas, y tú decides cómo están distribuidos los escritorios.

        Uso: Alojar tus máquinas virtuales (VMs), bases de datos y contenedores de forma segura.

    2. Cloud VPN (Virtual Private Network)
        Es un servicio de conectividad que crea un túnel cifrado a través de la internet pública.

        Función: Conecta de forma segura tu red local (on-premises) u otra red de nube con tu VPC.

        Analogía: Es como un túnel secreto y blindado que va desde tu casa directamente hasta tu oficina privada en el edificio.

        Uso: Permitir que tus empleados o tus servidores locales se comuniquen con los recursos en la nube como si estuvieran en la misma red física, sin exponer los datos a internet.
  

- Característica
    * Cloud VPC
    * Cloud VPN

- ¿Qué es?
  * Cloud VPC
    - Una infraestructura de red virtual.
  * Cloud VPN
    - Un método de conexión segura (túnel).

Propósito
  * Cloud VPC
    - Organizar y aislar recursos en la nube.
  * Cloud VPN
    - Conectar redes remotas de forma cifrada.

Componentes
  * Cloud VPC
    - Subredes, Firewalls, Rutas.
  * Cloud VPN
    - Puertas de enlace (Gateways), Túneles IPsec.

Dependencia
  * Cloud VPC
    - No necesita una VPN para funcionar internamente.
  * Cloud VPN
    - Necesita una VPC para tener a dónde conectarse.




???

Subnet: 10.3.0.0/28
  * GKE Master Server IP Address
    * CIDR Range (Reserverd)
    * K8s API Server ILB VIP


???    


* IAP: Identity Aware Proxy

* firewall rule with source as IAP IP Range     ???
* bastion VM accessible using IAP only          ???


***


### google_compute_address

* https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_address




### Copy Terraform Files to Bastion Host


gcloud compute scp --recurse 3-k8sresources-terraform-manifests "hr-dev-bastion-vm:/tmp" --zone "us-east1-b" --tunnel-through-iap --project "tutorialgcp001"


gcloud compute ssh --zone "us-east1-b" "hr-dev-bastion-vm" --tunnel-through-iap --project "tutorialgcp001"


4/0ATX87lMe4_q5kU3XQP7eiZZ_nQ8PNou_aYDiK4fWWITOMtJf-rkvVFGDsBKxZBAFHKVq4A


cat $HOME/.kube/config


### metadata_startup_script

*




















# Repaso y recordatorio

* En Kubernetes, el Control Plane (Plano de Control) es el cerebro que decide qué pasa, y estos tres componentes son sus empleados clave.

* kube-apiserver (El Mesero / La Ventanilla Única)
Es el único punto de contacto. Todo lo que quieras hacer en el cluster debe pasar por él.

Concepto: Es la puerta de entrada. Cuando tú usas kubectl apply, le estás enviando una carta al API Server. Él verifica quién eres (autenticación) y si tienes permiso para hacer eso (autorización).

En el restaurante: Es el mesero. Tú no vas a la cocina a hablar con el chef, hablas con el mesero. Él anota tu pedido, verifica que puedas pagarlo y lo lleva a donde corresponde.

Atributo clave: Es horizontalmente escalable. Puedes tener varios meseros si el restaurante se llena.

* kube-scheduler (El Recepcionista / Maitre d')
Su único trabajo es decidir en qué nodo va a vivir cada Pod.

Concepto: Mira los Pods que acaban de crearse y no tienen un lugar asignado. Revisa qué nodos tienen espacio (CPU, RAM) y elige el mejor.

En el restaurante: Es el maitre d' (la persona que te recibe en la puerta). Él mira cuántas personas vienen en tu grupo y revisa qué mesas están vacías. Si traes un grupo de 10, no te va a sentar en una mesa de 2.

Atributo clave: No mueve al Pod, solo decide dónde va. El que realmente "empuja" al Pod al nodo es otro componente llamado kubelet.


* kube-controller-manager (El Gerente de Operaciones)
Es el que se encarga de que la realidad coincida con lo que tú pediste (el "Estado Deseado").

Concepto: Es un conjunto de procesos (bucles de control). Por ejemplo, si dijiste que quieres 3 réplicas de una App y una se muere, el Controller Manager se da cuenta y ordena crear una nueva.

En el restaurante: Es el Gerente. Su trabajo es vigilar: "¿Hay suficientes platos limpios?", "¿Se terminó la comida?", "¿Se fue un mesero?". Si falta algo, él toma medidas para que todo siga funcionando como se planeó.

Atributo clave: Ejecuta varios "controladores" en uno solo (Node Controller, Job Controller, Endpoint Controller, etc.).





Componente	                Función Principal	
kube-apiserver	              Comunicación y validación.	
kube-scheduler	              Asignación de recursos (¿Dónde?).	
kube-controller-manager	      Mantener el orden y el estado.	




## El Viaje: De Terraform al Corazón de Kubernetes
Imagina que quieres crear __un Deployment (un grupo de contenedores)__ usando Terraform. Este es el camino que sigue tu instrucción:

1. El Plano (Terraform Local)
Cuando ejecutas terraform apply, Terraform lee tus archivos .tf.

Terraform Plan: __Crea un gráfico de dependencias__. Sabe que no puede enviar nada a Kubernetes si el cluster de GKE no está "Ready" (listo).

Estado (State): Revisa qué existe ya para no duplicar trabajo.

2. El Traductor (Provider de Kubernetes)
Terraform no habla "Kubernetes" de forma nativa; __usa un Provider__.

El provider toma tu código HCL y lo traduce a una llamada de API REST (un formato JSON que Kubernetes entiende).

Seguridad: El provider __busca tus credenciales__ (el archivo kubeconfig) para demostrarle a Google y a Kubernetes que tienes permiso.

3. La Puerta de Entrada (kube-apiserver)
Aquí es donde entran los conceptos que vimos antes. La llamada llega al kube-apiserver.

Autenticación: El API Server dice: "¿Es realmente el usuario de Terraform?".

Validación: "¿El formato del Deployment es correcto? ¿Pide demasiada memoria?".

__El Almacén (etcd)__: Si todo está bien, el API Server guarda tu deseo en una base de datos llamada etcd. Dato clave: Hasta este punto, ¡nada se ha creado todavía! Solo se ha "anotado el pedido".

4. La Decisión (kube-scheduler)
El kube-scheduler se da cuenta de que hay un nuevo pedido en etcd que no tiene una "casa" (un nodo).

Mira tus nodos disponibles, __revisa la RAM/CPU__ y dice: "Este Pod irá al Nodo A". Actualiza la información en el API Server.

5. La Ejecución (El Gerente y el Trabajador)
El kube-controller-manager se asegura de que, si pediste 3 réplicas, siempre haya 3.

 "El kubelet (el agente dentro de cada nodo) recibe la orden del API Server, descarga la imagen (de Docker, por ejemplo) y enciende el contenedor."