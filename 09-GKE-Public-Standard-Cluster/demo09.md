# "google_container_cluster"

El Concepto: ¿Qué es un "Cluster"?
Si una VM (Compute Engine) es como una computadora individual, un Cluster es como una orquesta.

Los Músicos (Nodos): Son máquinas individuales (VMs) que tocan los instrumentos.

El Director de Orquesta (Control Plane): Es el cerebro que le dice a cada músico qué parte de la partitura (tu código/contenedor) debe tocar.

El recurso google_container_cluster en Terraform es el encargado de crear tanto al Director como a los Músicos.


Atributos
location: Es el lugar del mundo donde estarán tus servidores. Puede ser Zonal (una sola ciudad, ej: us-central1-a) o Regional (tres ciudades al mismo tiempo para que si una falla, el cluster siga vivo).

initial_node_count: ¿Cuántas máquinas quieres encendidas desde el primer segundo? Si pones 3, tendrás 3 VMs listas para trabajar.

node_config: Aquí defines "cómo es" la máquina. ¿Cuánta memoria tiene? ¿Qué procesador usa?

oauth_scopes: Son los "permisos" de la máquina. El valor "cloud-platform" es el más común porque le permite a la máquina hablar con otros servicios de Google Cloud.



¿Por qué esto es diferente a una VM normal?
La gran diferencia es que en una VM tú eres el responsable de todo. En un Cluster:

Si una máquina se rompe, GKE la borra y crea una nueva automáticamente.

Si tienes mucho tráfico, GKE puede crear más máquinas solo.

Tú no instalas programas directamente; tú le das "Contenedores" (como Docker) y él decide dónde ponerlos.


## ¿Qué es un Node Pool (Piscina de Nodos)?
Si el Cluster es la orquesta completa, el Node Pool es un "grupo de músicos" específicos.

Por qué existen: Imagina que tienes una parte de tu código que necesita mucha memoria (músicos con instrumentos grandes) y otra que necesita mucha CPU (músicos que tocan muy rápido). No quieres que todos los nodos sean gigantes y caros.

La solución: Creas un Node Pool con máquinas baratas para tareas simples y otro Node Pool con máquinas potentes para tareas pesadas. Ambos viven dentro del mismo Cluster.

