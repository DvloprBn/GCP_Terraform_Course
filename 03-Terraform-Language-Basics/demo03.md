# vpc

El Enrutamiento de la VPC
Concepto: La VPC recibe el paquete y consulta su Tabla de Rutas.

En Terraform: Esto se gestiona automáticamente al crear la google_compute_network, pero puedes personalizarlo con google_compute_route.

Acción: La VPC dice: "Esta IP pertenece a mi subred de us-central1".




El Filtro de Seguridad (Firewall)
Concepto: Aquí es donde el paquete puede ser descartado. El Firewall revisa: ¿Viene de una IP permitida? ¿Va hacia un puerto abierto (ej. 80 o 443)?

En Terraform: Aquí actúa tu recurso google_compute_firewall.

Acción: Si no creaste la regla en Terraform, Google aplica la regla implícita de "Deny All" y el paquete muere aquí.







El Destino Final (Subnet e Instancia)
Concepto: El paquete llega a la subred y finalmente a la interfaz de red (NIC) de tu máquina virtual.

En Terraform: Definido por google_compute_subnetwork y la configuración network_interface dentro de tu google_compute_instance.




Paso,Componente,Acción,Definido en Terraform como...
1,Internet,
    El usuario envía la petición.,
    N/A (Externo)
2,VPC Routing,
    Se decide a qué subred enviar el tráfico.,
    google_compute_network
3,Firewall,
    Se verifica si el puerto está permitido.,
    google_compute_firewall
4,Subnetwork,
    El tráfico llega al segmento local.,
    google_compute_subnetwork
5,VM Instance,
    El software recibe los datos.,
    google_compute_instance






# Firewall    

El recurso google_compute_firewall es el "guardia de seguridad" de tu red. Sin él, tus máquinas virtuales estarían totalmente aisladas (no recibirían ni un solo paquete) o totalmente expuestas, dependiendo de la configuración.


Es "Stateful" (Con estado)
Si permites el tráfico de entrada (Ingress) en el puerto 80, GCP automáticamente permite el tráfico de salida (Egress) de respuesta. No necesitas crear una regla simétrica de salida; el firewall "recuerda" que esa conexión fue permitida.

Reglas Implícitas (Lo que no ves)
Toda VPC en Google Cloud nace con dos reglas invisibles que no aparecen en tu código de Terraform a menos que las sobrescribas:

Allow Egress All: Todo lo que esté dentro de la VPC puede salir a internet.

Deny Ingress All: Nadie desde internet puede entrar a menos que crees una regla específica.


Target Tags: El poder de las etiquetas
En lugar de aplicar reglas a direcciones IP específicas (que pueden cambiar), en GCP usamos Tags.

Si le pones el tag web-server a 10 VMs, y creas una regla de firewall que apunte a ese tag, las 10 máquinas quedan protegidas instantáneamente.


Atributos clave:
priority: Si tienes dos reglas que chocan, la que tenga el número más bajo gana.

source_ranges: Una lista de bloques CIDR. Si quieres permitir tráfico solo desde tu oficina, pondrías la IP de tu oficina aquí.

allow / deny: Puedes elegir permitir o bloquear explícitamente.



source_ranges (Basado en IPs):

Qué es: Una lista de bloques de direcciones IP en formato CIDR (ej. 10.0.0.0/24 o 0.0.0.0/0).

Cuándo usarlo: Cuando el tráfico viene de fuera de tu red (Internet) o de una red externa cuya IP conoces.

Ejemplo: Permitir que solo los empleados de tu oficina (con IP fija) entren por SSH.

source_tags (Basado en Identidad):

Qué es: Una lista de etiquetas que tienen otras instancias de VM dentro de la misma red.

Cuándo usarlo: Para comunicación interna entre microservicios.

Ejemplo: Tienes una base de datos que solo debe aceptar tráfico de las máquinas que tengan la etiqueta app-server. No te importan sus IPs, solo que tengan la etiqueta correcta.













# VM

Para que la VM sepa dónde "vivir", usaremos el atributo subnetwork dentro del bloque network_interface.

Inyección de Dependencias: Al usar google_compute_subnetwork.subnet_publica.id, Terraform entiende que la red debe crearse antes que la máquina.

Aislamiento: Si cambiaras la subred a subnet_privada y borraras el bloque access_config, tu máquina sería invisible desde internet.

Metadatos y Etiquetas (Tags): Las etiquetas en la instancia deben coincidir con las de tus reglas de google_compute_firewall para que el tráfico fluya.


Identidad y Seguridad (Service Accounts)
Por defecto, una VM no debería tener acceso a otros servicios de Google (como un Bucket de Storage) a menos que le des una "identidad".

Buena práctica: No uses la cuenta de servicio por defecto. Crea una específica con el principio de menor privilegio.



Atributos Avanzados de la VM
Atributo    Propósito   Por qué usarlo
allow_stopping_for_update
    Permite apagar la VM para cambiar el tipo de máquina.
    Si quieres pasar de e2-micro a e2-medium sin errores.
service_account
    Define qué permisos tiene la VM dentro de GCP.
    Seguridad (evita usar llaves JSON).
boot_disk.device_name
    Nombre interno del disco.
    Ayuda a identificar discos en scripts de Linux.

