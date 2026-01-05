# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute
# Resource: VPC
resource "google_compute_network" "myvpc" {
  name = "vpc1"
  auto_create_subnetworks = false   
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_subnetwork
# Resource: Subnet
resource "google_compute_subnetwork" "mysubnet" {
  name = "subnet1"
  region = var.region
  # ip_cidr_range: 
  ip_cidr_range = "10.128.0.0/20"
  network = google_compute_network.myvpc.id 
}


/*
El Concepto: ¿Qué es realmente una VPC en GCP?
Imagina que Google Cloud es un océano gigante de servidores. 
Sin una VPC, tus recursos estarían flotando ahí, expuestos y mezclados con los de todos los demás.

Es Global: A diferencia de otros proveedores (como AWS o Azure), la VPC en GCP es global. 
No pertenece a una sola ciudad o país. Puedes tener una red única que abarque todo el mundo.

Es un Contenedor Lógico: No es un cable físico. Es una configuración de software que le dice a Google: 
"Cualquier tráfico que ocurra entre estas IPs me pertenece y nadie más puede verlo".

Subredes Regionales: Aunque la VPC es global, las subredes son regionales. 
Es como si tu VPC fuera una empresa mundial y las subredes fueran las oficinas locales en Nueva York, Madrid o Tokio.

Cuando usas Terraform para crear una VPC, no estás simplemente ejecutando un comando de "crear". Estás definiendo un Estado Deseado.



El Grafo de Dependencias
Terraform crea un mapa mental. Él sabe que:

No puede crear una Subred si no existe la VPC.

No puede aplicar una Regla de Firewall si no sabe a qué VPC pertenece.

En tu código, cuando pones network = google_compute_network.vpc_fortaleza.id, le estás diciendo a Terraform: "Espera a que la red esté lista, toma su identificación única y dásela a la subred". A esto se le llama dependencia implícita.

El concepto de "Recurso" vs "Atributo"
Recurso: El bloque de construcción (ej. la red completa).

Atributo: Las características que definen el comportamiento (ej. routing_mode = "GLOBAL" o REGIONAL).














Analogia: 

El Hotel
Para que no se te olvide el concepto, usa esta analogía:

VPC: Es el Hotel. Es el edificio completo y el nombre de la propiedad.

Subredes: Son los Pisos del hotel. El piso 1 es para clientes de EE. UU., el piso 2 para clientes de Europa.

Direcciones IP: Son los Números de Habitación.

Firewall: Es el Personal de Seguridad en la puerta. Él tiene una lista de quién puede entrar (IPs permitidas) y a qué piso (Subred) puede ir.

Terraform: Es el Plano Arquitectónico. Si cambias algo en el plano y haces terraform apply, Terraform irá al hotel y moverá las paredes o cambiará al guardia de seguridad para que coincida con tu plano.




*/