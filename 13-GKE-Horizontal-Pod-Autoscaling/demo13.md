# Kubernetes Horizontal Pod Autoscaling

* Automatically increase or decrease number of pods in respons to:
    * Workloads CPU and Memory Utilization
    * Custom metrics reported from within kubernetes Cluster 
    * External metrics (Load Balancers, messaging Services, ...)
    * Custom metrics using Managed Service for Prometheus

* HPA automatically scales the pods in workloads types:
    * Kubernetes RecplicaSet
    * Kubernetes Replication Controller
    * Kubernetes Deployment
    * Kubernetes SatefulSet


* This can help our applications
    * __Scale out__ to meet increased demand or
    * __Scale in__ when resources are not needed, thus freeing up your worker nodes for other applications


* HPA Imperative ffCommand : Kubectl autoscale deployment my-app --max 6 --min 4 --cpu-percent 50


## Kubernetes Metrics Server


* Metric Server collects resource metrics from __kubelets and exposes themin kubernetes apiserver__ through __Metrics API__

* Metrics API can also be accessed by __kubectl top__, making it easier to debug autoscaling pipelines.

* Fast Autoscaling solution, __collecting metrics every 15 seconds__.
Metric Server is not mean for __non-autoscaling purposes__. For example, don'y use it to forward metrics to monitoring solutiuons.

* Resource efficiency, __using 1 mili core if CPU and 2 MB of memory__ for each node in a cluster.

* Metric Server used for __CPU/Memory__ based __horizontal autoscaling__.

* Metric Server used for automatically adjusting/ suggesting resources needed by containers (__Vertical Autoscaling__)  