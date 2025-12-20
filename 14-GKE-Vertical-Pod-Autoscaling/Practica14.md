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




* Downtime es el tiempo en que un servicio no está disponible.

* "The VPA caused some downtime while resizing the pod."



### Esto activa el "cerebro" del VPA en el cluster
  vertical_pod_autoscaling {
    enabled = true
  }




#### Reglas Generales

    > Modo "Off": Puedes poner el VPA en modo Off (en lugar de Auto). Así solo te dará recomendaciones en los logs pero no matará tus Pods. Es ideal para aprender cuánto recurso consumen tus apps sin romper nada.
    
    > No los mezcles: Por regla general, no uses VPA y HPA al mismo tiempo para el CPU o la RAM, porque se vuelven locos peleando por el control del Pod.
    
    > Ideal para: Apps que no pueden "clonarse" fácilmente (como bases de datos o procesos únicos) pero que necesitan crecer en potencia.









kubectl run -i --tty load-generator --rm --image=busybox --restart=Never -- /bin/sh -c "while sleep 0.01; do wget -q -O- http://myapp1-cip-service; done"





    * Fragmento,    ¿Qué significa en simple?,  Explicación técnica
    kubectl run load-generator,
                    """Crea un ayudante temporal"".
                                                ",Crea un Pod llamado load-generator.
    
    -i --tty,
                    """Mantén la ventana abierta"".",
                                                Abre una sesión interactiva (te permite ver lo que pasa en tiempo real).
    
    --rm,
                    """Bórrate al terminar"".",
                                                "SRE Tip: Muy importante. Cuando detengas el proceso (Ctrl+C), el Pod se eliminará automáticamente para no dejar basura en el cluster."
    
    --image=busybox,
                    """Usa una caja de herramientas"".
                                                ",busybox es una imagen de Linux mínima que tiene herramientas como wget.
    
    --restart=Never,
                    """No revivas si mueres"".
                                                ","Le dice a Kubernetes que si el Pod falla, no intente reiniciarlo (ideal para tareas de un solo uso)."
    
    "-- /bin/sh -c ""...""",
                    """Ejecuta esta orden"".
                                                ",Todo lo que sigue es el guion o script que el Pod va a seguir.




2. El "Bucle Infinito" (El motor de la carga)
La parte final: "while sleep 0.01; do wget -q -O- http://myapp1-cip-service; done"

while true (implícito): Significa "haz esto para siempre hasta que yo te detenga".

sleep 0.01: Espera una centésima de segundo entre cada petición. Esto genera ráfagas de tráfico muy rápidas.

wget -q -O- http://...:

wget: Es el comando para descargar/pedir una página web.

-q: Modo "quiet" (silencioso), para no llenar tu pantalla de basura.

-O-: Tira el contenido descargado a la "nada" (no lo guarda, solo lo procesa).

http://myapp1-cip-service: Es la dirección de tu aplicación.

En resumen: Estás pidiendo la página web de tu app cientos de veces por segundo.


3. ¿Para qué la usaste? (Contexto SRE)
La usaste para simular tráfico real masivo. En tu proyecto de aprendizaje:

Tu CPU empezó a trabajar más de lo normal para responder a tantas peticiones.

El HPA detectó que el CPU subió.

Al ver que el CPU pasó el límite que pusiste en Terraform, el HPA creó más Pods.




## Kubernetes Manifest

El kubernetes_manifest te permite copiar y pegar cualquier YAML de Kubernetes directamente en tu código de Terraform.

La analogía: Si los recursos normales de Terraform son piezas de LEGO con formas fijas, el kubernetes_manifest es una impresora 3D que puede crear cualquier pieza que tú diseñes.

En un entorno real de GCP, a veces necesitas que Terraform cree primero el cluster de GKE y luego el manifiesto. Si el manifiesto intenta crearse antes de que el cluster esté listo, fallará.

use kubernetes_manifest to manage Custom Resources that are not yet supported by the standard provider."


Bloque,¿Qué le dice a Kubernetes?
* targetRef,
    * "¿A quién vigilar? Aquí conectas el VPA con tu aplicación. Al usar kubernetes_deployment_v1.myapp1...name, estás creando una dependencia dinámica en Terraform (si el nombre del deployment cambia, el VPA se actualiza solo)."

* "updateMode = ""Auto""",
    * "¿Cómo actuar? Si el VPA decide que el Pod necesita más RAM, lo matará y lo reiniciará con el nuevo tamaño. (Recuerda: esto causa una pequeña interrupción si solo tienes una réplica)."

* controlledResources,
    * ¿Qué vigilar? Le pides que ajuste tanto el CPU como la Memoria.

* minAllowed,
    * "El suelo. Aunque tu app no esté haciendo nada, nunca le des menos de 25m de CPU o 50Mi de RAM. Esto evita que el Pod sea demasiado débil para arrancar."

* maxAllowed,
    * "El techo (Protección de cartera). Evita que, si tu app tiene un error (como un memory leak), empiece a consumir recursos infinitos y te dispare la factura de GCP."












## Analogia Ejemplo

* Una aplicación corriendo en GKE (Google Kubernetes Engine) como si fuera una persona usando una camiseta.

    + El problema: Si la persona crece, la camiseta le queda chica (el Pod se queda sin RAM y truena: OOMKilled). Si la persona adelgaza, la camiseta le queda enorme (estás desperdiciando dinero en GCP porque pagas por RAM que no usas).
    
    + La solución (VPA): El Vertical Pod Autoscaler es como un sastre automático. Mide a la persona constantemente y le cambia la camiseta por una de su talla exacta.


* 3 pasos simples
        1. Observa: El VPA mira cuánto CPU y RAM está gastando tu Pod realmente mientras trabaja.

        2. Recomienda: Dice: "Oye, le pusiste 2GB de RAM, pero solo usa 500MB. Deberías bajarle".

        3. Actúa (El costo): Aquí está el truco: Para cambiarle la "camiseta" al Pod, el VPA tiene que matar el Pod y volverlo a encender con el nuevo tamaño. (Esto es diferente al HPA, que solo crea clones).


* Ejemplo práctico: El "Script Glotón"
    + Un script de Python que procesa datos:

        - Mañana: Procesa 10 filas (Usa 100MB RAM).

        - Tarde: Procesa 1,000,000 de filas (Usa 4GB RAM).

    + Sin VPA: Tendrías que configurar el Pod con 4GB siempre "por si acaso", y estarías regalándole dinero a Google toda la mañana. 
    
    + Con VPA: El VPA detecta que en la tarde necesita más "músculo", reinicia el Pod con 4GB y, cuando termina la carga pesada, lo regresa a una talla chica para ahorrar.



__VPA vs HPA__

    * HPA (Horizontal): Si hay mucha gente en la fila, abre más cajas registradoras (más Pods).

    * VPA (Vertical): Si el cajero está muy lento porque tiene mucho trabajo, le da una mejor computadora o más café (más CPU/RAM al mismo Pod).








Nota: 
        Si el VPA era el sastre que te cambiaba la talla de la camiseta (hacer el Pod más grande), el HPA (Horizontal Pod Autoscaler) es el gerente de un supermercado que abre más cajas cuando hay mucha gente.

        En el mundo de Kubernetes y GKE, el HPA es el tipo de escalado más utilizado porque permite que tu aplicación soporte más tráfico sin interrumpir el servicio.