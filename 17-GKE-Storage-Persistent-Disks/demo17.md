# GCP Google Kubernetes Engine - GKE Storage

## Kubernetes Storage compute Engine Persistent Disks

## GKE Autopilot cluster + Compute engine persistent disks as storage

## Deploy UserMgmt WebApp on GKE with MySQL as Database using Terraform


### Introduction

* Create Terraform configs for following Kubernetes Resources
* Kubernetes Storage Class
* Kubernetes Persistent Volume Claim
* Kubernetes Config Map
* Kubernetes Deployment for MySQL DB
* Kubernetes ClusterIP Service for MySQL DB
* Kubernetes Deployment for User Management Web Application
* Kubernetes Load Balancer for UMS Web App




### Pre-requisite: Verify Compute Engine persistent disk CSI Driver enabled

* Go to GKE cluster -> DETAILS -> FEATURES -> Compute Engine persistent disk CSI Driver should be enabled


#### Kubernetes storage - key Resources

* PD - persistent disk

* Kubernetes Storage Class
    * StorageClass (El Menú): Es donde defines qué tipo de disco quieres. En GCP tienes:

        pd-standard: Discos duros tradicionales (lentos pero baratos).

        pd-ssd: Discos de estado sólido (rápidos).

        pd-balanced: Un equilibrio entre costo y rendimiento.

        Ejemplo: Es como elegir entre un trastero con aire acondicionado (SSD) o uno básico en el sótano (Standard).

    * Provides a way for administrator to define the __classes of storage they offer__
        * standard-rwo: Provides balanced disks
        * premium-rwo: Provides SSD disks
        * kubectl describe sc premium-rwo
            * type=pd-ssd
        * kubectl describe sc standard-rwo
            * type=pd-balanced
    
    
    
    * Kubernetes Cluster
      * Default Namespace
        * mypod1
          * pvc (K8s Persistent Volume Claim) is a namespace level resource
            * SC (K8s Storage Class - cluster level resource) -- > pv (K8s Persistent Volume - cluster level resource)


    * ¿Qué es un StorageClass?
        * El __PersistentVolume (PV) es el disco físico__ y
        * El __PersistentVolumeClaim (PVC) es la solicitud del usuario__, 
        * El __StorageClass (SC) es el perfil de configuración__ que define cómo se debe crear ese disco automáticamente.

        Antes de que existieran los StorageClasses, los administradores tenían que crear los discos manualmente en GCP/AWS y luego crear un PV para cada uno. Con StorageClass, el proceso es dinámico: el disco se crea en el momento en que alguien lo necesita.

    * La Analogía: El Servicio de Alquiler de Coches
        Imagina que quieres alquilar un coche (un disco):

        StorageClass: Es el catálogo de la empresa. Tienes categorías: "Económico", "Lujo", "SUV". Cada categoría tiene un precio y características distintas.

        PVC: Es tu reserva. Dices: "Quiero un coche de la categoría 'Lujo'". No te importa cuál coche exacto sea, siempre que cumpla con el perfil.

        PV: Es el coche específico (con su matrícula/ID) que te entregan en la puerta.

    * Componentes de un StorageClass
        Cuando defines un StorageClass en YAML o Terraform, estos son los campos más importantes:

        Provisioner (El Proveedor): Determina qué servicio de nube creará el disco. Para GCP es pd.csi.storage.gke.io.

        Parameters (Los Detalles): Aquí defines el tipo de disco.

        type: pd-standard, pd-ssd, pd-balanced.

        Reclaim Policy (Política de Reclamo): ¿Qué pasa con el disco físico cuando borras el PVC?

        Delete: El disco se borra automáticamente (ahorras dinero).

        Retain: El disco se queda ahí para que recuperes los datos manualmente.

        AllowVolumeExpansion: Si se pone en true, puedes editar el PVC más tarde para aumentar el tamaño del disco sin borrar nada.


    * Ej:
      * apiVersion: storage.k8s.io/v1
        kind: StorageClass
        metadata:
            name: disco-rapido-ssd
        provisioner: pd.csi.storage.gke.io
        parameters:
            type: pd-ssd
            replication-type: none
        reclaimPolicy: Delete
        allowVolumeExpansion: true





* Kubernetes Persistent Volume - PV
    * PersistentVolumeClaim - PVC (La Solicitud): Es el ticket que crea el desarrollador diciendo: "Necesito 10GB de espacio tipo SSD".
    * apiVersion: v1
        kind: PersistentVolumeClaim
        metadata:
        name: mi-pvc-datos
        spec:
        accessModes:
            - ReadWriteOnce
        resources:
            requests:
            storage: 10Gi
        storageClassName: premium-rwo # Este sería el PD-SSD


    * In GKE, a __PersistentVolume__ is typically backed by a __Google persistent disk__.
    * A PersistentVolume can be __dynamically provisioned__, we do not have to __manually__ create and delete the backing storage.
    * PersistentVolume resources are cluster resources that exists__ independently__ of pods.
        * Doesn't impact due to __cluster changes__
        * Doesn't impact due to __pods deleted or recreated__.
    * PersistentVolume will be __provisioned based on configurations__ defined in Storage Class and Persistent Volume Claim
        * Storage Class: Storage type (pd-balanced, pd-ssd)
        * PVC: 
            * Size: 1GB, 2GB
            * Access Modes: 
                * ReadWriteOnce, 
                * ReadOnlyMany,
                * ReadWriteMany
    * Resource Types [Important]
        * Storage Class and Persistent Volume or __cluster level resources__.
        * 


    * ¿Qué es un Persistent Volume (PV)?
        Si el StorageClass era el catálogo de servicios, el Persistent Volume (PV) es el recurso físico real (el disco) ya aprovisionado en tu infraestructura.

        Es un objeto del clúster que representa un trozo de almacenamiento. A diferencia de un volumen normal, el ciclo de vida de un PV es independiente de los Pods. Si el Pod muere, el PV permanece con los datos intactos (dependiendo de su configuración).

    * La Analogía: El Aparcamiento Reservado
        Siguiendo con analogías que facilitan la comprensión:

        La Infraestructura (GCP): Es el terreno donde se construye el aparcamiento.

        El PV (Persistent Volume): Es una plaza de aparcamiento numerada y delimitada (ej. Plaza #42). Ya existe, tiene un tamaño fijo y está ahí esperando a ser usada.

        El PVC (Claim): Es el conductor que llega con un permiso que dice "Tengo derecho a una plaza de 5 metros".

        El Pod: Es el coche que finalmente se estaciona en esa plaza.

    * Estados de un Persistent Volume
        Un PV pasa por varios estados (Phases) que debes monitorear como SRE:

        Available: El disco está libre y listo para que alguien lo reclame.

        Bound: El disco ya ha sido asignado a un PVC específico.

        Released: El PVC ha sido borrado, pero el clúster aún no ha liberado el recurso (los datos siguen ahí).

        Failed: Hubo un error al intentar reclamar o borrar el disco.



    * Nota de experto: En entornos modernos de nube como GKE, el 90% de las veces usarás aprovisionamiento dinámico. El PV se crea "mágicamente"    cuando aplicas tu YAML de PVC.


      * Ej: 
      * apiVersion: v1
        kind: PersistentVolume
        metadata:
        name: pv-manual-datos
        spec:
        capacity:
            storage: 50Gi
        accessModes:
            - ReadWriteOnce
        gcePersistentDisk:
            pdName: mi-disco-existente-en-gcp
            fsType: ext4






* Kubernetes Persistent Volume Claim - PVC
    * PersistentVolume - PV (El Disco Real): Es el recurso físico en Google Cloud (el disco de Compute Engine) que se "atacha" al nodo donde vive tu Pod.
    * Persistent Volume Claim: PVC onjects request a __specific size, access mode, and StorageClass__ for the PersistentVolume. 
    * If a PersistentVolume that satisfies the request __exists or can be provisioned__, the PVC is bound to that PersistentVolume.
    * Access Modes:
        * ReadWriteOnce: The volume can be mounted as __read-write by a single node__.
        * ReadOnlyMany: The volume can be mounted __read-only by many nodes__.
        * ReadWriteMany: The volume can be mounted as __read-write by many nodes
            * PersistentVolume resources that are backed by __Compute Engine persistent disks don't support__ this access mode.


    * Sin él, los Pods no sabrían cómo pedir el espacio que necesitan.

    * ¿Qué es un Persistent Volume Claim (PVC)?
        Si el Persistent Volume (PV) es el recurso físico (el disco), el Persistent Volume Claim (PVC) es la solicitud formal de un usuario o de un Pod para obtener ese almacenamiento.

        Es un ticket de pedido. En lugar de que el desarrollador tenga que saber qué discos hay disponibles en GCP, simplemente crea un PVC diciendo: "Necesito un disco de 20GB que sea rápido (SSD) y que solo yo pueda escribir en él".


    * La Analogía: El Carnet de la Biblioteca
        Imagina que el almacenamiento de Google Cloud es una Biblioteca:

        Persistent Volume (PV): Son los libros reales que están en los estantes. Cada libro tiene un título, un número de páginas y un género.

        Persistent Volume Claim (PVC): Es tu solicitud de préstamo. Tú vas al mostrador y dices: "Busco un libro de misterio de más de 300 páginas".

        El Binding (Vinculación): El bibliotecario busca un libro (PV) que coincida con tu solicitud (PVC). Si lo encuentra, te lo entrega. Ahora ese libro está "atado" a ti hasta que lo devuelvas.

    * Cómo funciona el "Binding" (Vinculación)
        Cuando creas un PVC, Kubernetes busca un PV que cumpla con los requisitos. Si lo encuentra, los vincula permanentemente.

        Si estás usando un StorageClass, el proceso es aún más eficiente:

        Creas el PVC.

        Kubernetes ve que no hay ningún PV libre que coincida.

        Kubernetes le pide al StorageClass que cree un disco nuevo en Google Cloud al instante.

        GCP crea el disco, Kubernetes crea el PV automáticamente y lo vincula a tu PVC.

    * Atributos clave de un PVC
        Para configurar un PVC, debes definir estos tres puntos:

        Resources (Capacidad): Cuánto espacio necesitas (ej. 10Gi).

        Access Modes (Modos de acceso): Cómo se conectará el Pod al disco:

        ReadWriteOnce (RWO): El disco solo puede ser montado por un solo Nodo (lo más común para bases de datos).

        ReadOnlyMany (ROX): Muchos Nodos pueden leer el disco al mismo tiempo.

        ReadWriteMany (RWX): Muchos Nodos pueden leer y escribir (requiere servicios especiales como Filestore en GCP).

        StorageClassName: Qué "perfil" de disco quieres usar.


    * Ej:
      * apiVersion: v1
        kind: PersistentVolumeClaim
        metadata:
        name: pvc-mi-app
        spec:
        accessModes:
            - ReadWriteOnce
        resources:
            requests:
            storage: 15Gi
        storageClassName: premium-rwo # Referencia al StorageClass














---


### Kubernetes Storage: Google Compute Engine (GCE) Persistent Disks


* En el mundo de Kubernetes, los Pods son efímeros. Esto significa que si un Pod muere o se reinicia, cualquier dato que haya guardado en su disco local desaparece. Para evitar esto, usamos Persistent Disks (PD) de GCP.

* La Analogía: El Hotel y el Trastero (o Bodega)
        Imagina que Kubernetes es un gran hotel.

        Un Pod es un huésped que alquila una habitación.

        Si el huésped se va (el Pod muere), el hotel limpia la habitación y todo lo que no estaba "atado" se tira a la basura.

        Para que el huésped no pierda sus cosas, el hotel ofrece un servicio de Trasteros Externos (Compute Engine Persistent Disks).

        El huésped pide un trastero (PersistentVolumeClaim o PVC).

        El hotel le asigna una llave y un espacio numerado (PersistentVolume o PV).

        Si el huésped se cambia de habitación o se va y viene otro, la maleta sigue segura en el trastero. Solo hay que conectar el nuevo "huésped" al trastero existente.



* ¿Por qué usar GCE Persistent Disks en K8s?
    Alta Disponibilidad: Si el nodo donde corre tu base de datos falla, Kubernetes mueve el Pod a otro nodo y "desenchufa" el disco del nodo viejo para "enchufarlo" en el nuevo automáticamente.

    Snapshots: Puedes tomar fotos de tus discos para respaldar la información.

    Redimensionamiento: Puedes aumentar el tamaño del disco sin necesidad de apagar el Pod.





* Persistent Disks - Default Storage Class
  * Standard - kubernetes.io/gce-pd - __OLD__ (No Recommended)
  * stabdard-rwo (Balanced Disk)
    * uses __CSI Provisioner__ (Container Storage Interface - GKE PD CSI) - LATEST & CREATES
  * premium-rwo (SSD Disk)
    * uses __CSI Provisioner__ (Container Storage Interface - GKE PD CSI) - LATEST & CREATES


    * Es necesario tener activo el Cluster Feature o el atrbuto del cluster
      * Compute engine persistent disk CSI Driver = Enabled







Note 1: PVC Claims must exist in the __same namespaces as the Pod__ using the claim. The cluster finds the claim in the Pod's namespace and uses it to get the __PersistentVolume__ backing the claim.

Note 2: A persistentVolume (PV) is a piece of storage in the cluster thtat has been provisioned by an administrator or dynamically provisioned using StorageClasses. It is a __resouce in the cluster just like a node is a cluster resource__.

Note 3: PVC Status changes from __Pending to Bound__ after MySQL Deployment.


    * MySQL Depolyment
      * Pod
      * ReplicaSet
      * Deployment 


* Load Balancer - svc
  * userMgmt Deployment
      * Pod <-- K8s ReplicaSet <-- K8s Deployment
    * Svc = MySQL K8s ClisterIP Service
  * MySql Deployment
      * Pod <-- K8s ReplicaSet  <--  k8s Deployment
* PVC <---> PV <-- SC
* SC --->  PV   --> Compute Engine Persisten Disk








&B25m?e3Xc_N0wZ*t








---




kubectl run -it --rm --image=mysql:8.0 --restart=Never mysql-client -- mysql -h mysql -pdbpassword11


kubectl delete -f 2-k8sresources-yaml