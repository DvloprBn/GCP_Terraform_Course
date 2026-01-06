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



* Kubernetes Persistent Volume Claim - PVC
    * PersistentVolume - PV (El Disco Real): Es el recurso físico en Google Cloud (el disco de Compute Engine) que se "atacha" al nodo donde vive tu Pod.
    * Persistent Volume Claim: PVC onjects request a __specific size, access mode, and StorageClass__ for the PersistentVolume. 
    * If a PersistentVolume that satisfies the request __exists or can be provisioned__, the PVC is bound to that PersistentVolume.
    * Access Modes:
        * ReadWriteOnce: The volume can be mounted as __read-write by a single node__.
        * ReadOnlyMany: The volume can be mounted __read-only by many nodes__.
        * ReadWriteMany: The volume can be mounted as __read-write by many nodes
            * PersistentVolume resources that are backed by __Compute Engine persistent disks don't support__ this access mode.
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





