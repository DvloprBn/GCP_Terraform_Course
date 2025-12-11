# Google Kubernetes Engine
* https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/container_cluster
* https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/client_config
* https://registry.terraform.io/providers/hashicorp/google/latest/docs/guides/using_gke_with_terraform
* https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/deployment_v1
* https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service_v1




--- 

* cat .kube/config = para revisar la configuracion de Kubernetes



- Alcance No Recomendado
provider "kubernetes" {
  config_path = "~/.kube/config"
}



- Alcance Recomendado - Project Sample
provider "kubernetes" {
  host                   = "https://${data.google_container_cluster.gke.endpoint}"
  cluster_ca_certificate = base64decode(data.google_container_cluster.gke.master_auth.0.cluster_ca_certificate)
  token                  = data.google_client_config.default.access_token
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "gke-gcloud-auth-plugin"
    # Additional Reference: https://registry.terraform.io/providers/hashicorp/google/latest/docs/guides/using_gke_with_terraform#using-the-kubernetes-and-helm-providers
  }  
}
- Doc Sample
provider "kubernetes" {
  host  = "https://${data.google_container_cluster.my_cluster.endpoint}"
  token = data.google_client_config.provider.access_token
  cluster_ca_certificate = base64decode(
    data.google_container_cluster.my_cluster.master_auth[0].cluster_ca_certificate,
  )
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "gke-gcloud-auth-plugin"
  }
}

---

* Kubernetes Deplyment and Service using Terraform + "Terraform Remote State Data Source" concept



## Terraform Remote State Data Source

The __terraform_remote_state__ data source retrives the __root module output values__ from __Project-1__ Terraform configuration, using the latest  state snapshot from the remote backend





* Project-1
  * Terraform Resources
    1. GKE Cluster
       * dev/gke-cluster-public/default.tfstate




* Project-3
  * Terraform Resources
    1. Kubernetes Provider
    2. Kubernetes Deployment
    3. kubernetes Load Balancer Service 
        * dev/k8s-demo1/default.tfstate


                        Data Source
de Project-2 ---> __Terrafomr_remote_state__ ---> dev/gke-cluster-public/default.tfstate


__Outputs from Project-1__:
1. GKE Cluster Name
2. GKE Cluster Location



* Terrafomr __Remote Sate Data Source__ concept to access __outputs from Project-1__
* __Kubernetes Provider__ to connect to __GKE Cluster__ created using Project-1
* Kubernetes __Deployment__ using Terraform
* Kubernetes __Load Balancer Service__ using Terraform.





---



Para sobrescribir un recurso en Terraform, generalmente se utiliza el comando terraform apply con un plan previamente generado que incluya los cambios deseados. El proceso comienza con terraform plan -out=tfplan para crear un plan de ejecución que se puede guardar y luego aplicar posteriormente con terraform apply tfplan.
 Este enfoque permite controlar exactamente qué cambios se aplicarán, incluyendo la sobrescritura de recursos existentes.

Si se desea modificar específicamente un recurso, se puede usar la opción -target=resource en terraform apply para limitar la operación a un recurso específico y sus dependencias.
 Esto es útil cuando se quiere sobrescribir solo ciertos recursos sin afectar al resto de la infraestructura.

Además, para obtener una lista clara de los recursos que se modificarán, se puede usar terraform show -json tfplan | jq '.resource_changes[] | select(.change.actions == "update" or .change.actions == "create" or .change.actions == "delete") | .address' para filtrar y mostrar solo los recursos que se crearán, actualizarán o eliminarán.
 Esta técnica ayuda a visualizar los cambios antes de aplicarlos.

En casos avanzados, si se necesita una lógica más compleja para definir valores predeterminados o manejar atributos opcionales, se puede utilizar la función coalesce() en combinación con variables locales para establecer valores por defecto, como http_port = coalesce(var.lb_frontend.http_port, 80).
 Aunque esta no es una sobrescritura directa, permite controlar cómo se interpretan los valores nulos o no definidos en los recursos.

Finalmente, es importante tener en cuenta que la sobrescritura de recursos puede implicar la eliminación y recreación de estos, especialmente si se cambian atributos que no son modificables in situ. Por ello, es fundamental revisar el plan generado con terraform plan antes de aplicar cualquier cambio para asegurarse de que los resultados sean los esperados.



--- 


# Clean-Up Files
rm -rf .terraform*
rm -rf terraform.tfstate*