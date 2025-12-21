# Google Kubernetes Engine

## Create GKE Standard Private Clsuter with k8s API Srever Private Endpoint

* GKE Standard Private Clsuer with Private Kubernetes API Server Endpoint.


* Last Secure Option
    * Public endpoint access: Enabled
    * Authorized NEtworks: Disabled
    * Accesible via Internet

Usando  __kubectl__    sera posible acceder al __GKE Cluster__ via internet.



* Medium Secure Option.
    * Public endpoint access: Enabled
    * Authorized NEtworks: Enabled
    * Accesible via __authorized Internet IPranges__ (Example: CloudShell, local desktop, from specified network in authorized network) 




* High Secure option:
    * Public endpoint access: Enabled
    * Accesible via
        * __VM__ in google cloud VPC network
        * __On-Premise network__ provided Cloud VPN or Cloud Interconnect is configured.