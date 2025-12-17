# VPA - Vertical Pod Autoscaler

## GKE Vertical Pod autoscaler

* Vertical Pod Autoscaling:
    * Lets you __analyze and set__ CPU and memory resources required by pods.
* Manual:
    * VPA recommends cpu and memory requests and limits.
    * We can review the recommendation and update the values manually.
* Automatic:
    * VPA recommends and automatically update the cpu and memory requests and limits
    * VPA evicts and recreates the pod during the resource request updates.

* Standard vs autopilot clusters
    * VPA need to be enabled at workload level for standard clusters
    * VPA is by default enabled in Autopilot clusters.
* Benefits:
    * Cluster nodes are used efficiently because Pods use exactly what they need.
    * you don't have to run time-consuming __benchmarking tasks to determine__ the correct values for CPU and memory requests.
    * Pods are scheduled onto nodes that have the appropriate resources available.
    * Runs Vertical Pod Autoscaler Pods as __control plane processes__ instead of Deployment on worker nodes (__GKE Special Feauture__)
* Important Note:
    * __Enable Cluster Autoscaler__ before enabling VPA.
    * VPA __can talk to Cluster Autoscaler__ to increase the number of nodes if needed for the VPA enabled workloads.