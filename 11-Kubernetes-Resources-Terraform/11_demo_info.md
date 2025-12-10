# Google Kubernetes Engine

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


                        Date Source
de Project-2 ---> __Terrafomr_remote_state__ ---> dev/gke-cluster-public/default.tfstate


__Outputs from Project-1__:
1. GKE Cluster Name
2. GKE Cluster Location



* Terrafomr __Remote Sate Data Source__ concept to access __outputs from Project-1__
* __Kubernetes Provider__ to connect to __GKE Cluster__ created using Project-1
* Kubernetes __Deployment__ using Terraform
* Kubernetes __Load Balancer Service__ using Terraform.