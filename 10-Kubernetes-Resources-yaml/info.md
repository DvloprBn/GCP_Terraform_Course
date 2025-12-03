# 10-Kubernetes-Resources-yaml



- Kubernetes Deployment
- Kubernetes Load Balancer Service





* Load Balancer Service
        El Balanceador de Carga (Load Balancer) es un servicio de red fundamental en Google Cloud Platform (GCP) que garantiza que tus aplicaciones sean rápidas, estén disponibles de forma continua y puedan manejar grandes cantidades de tráfico.🎯 ¿Qué es un Balanceador de Carga?Un Balanceador de Carga es un componente de red virtual que actúa como un punto de entrada único para todo el tráfico de usuarios dirigido a tu aplicación. Su trabajo principal es recibir ese tráfico y distribuirlo de manera inteligente entre un conjunto de servidores o recursos de procesamiento subyacentes (los backends).Piensa en él como un director de orquesta 🎼 o un conserje en un edificio con muchos ascensores. En lugar de que todos los usuarios intenten acceder al mismo servidor, el balanceador los redirige al servidor que tenga menos carga o esté más cerca.⚙️ ¿Cómo Funciona un Load Balancer en GCP?El funcionamiento en GCP se basa en un conjunto de reglas y componentes que trabajan juntos para lograr la distribución óptima.1. Componentes ClaveComponenteFunciónFrontend (o Regla de Reenvío)Es la interfaz pública. Define la dirección IP (externa o interna) y los puertos donde el balanceador escucha el tráfico de los usuarios.BackendEs el conjunto de recursos que ejecutan tu aplicación, como grupos de instancias de VM, grupos de nodos de GKE, Cloud Run, o Cloud Functions. El tráfico se envía a estos grupos.Health Checks (Comprobaciones de Salud)Son pings periódicos que el balanceador envía a los backends. Si un servidor no responde a la comprobación de salud, el balanceador lo marca como inactivo y deja de enviarle tráfico, garantizando la tolerancia a fallos.Mapas de URL (solo L7)En los balanceadores de capa 7 (HTTP/S), definen cómo enrutar el tráfico basándose en la URL o ruta (ej. el tráfico a /api va a un grupo de servidores y el tráfico a /images va a otro).2. Algoritmo de DistribuciónEl balanceador utiliza algoritmos (como Round Robin o mínimas conexiones) para decidir a qué servidor enviar el tráfico.3. Escalado AutomáticoEl balanceador de carga está íntimamente ligado a los Grupos de Instancias Administradas (Managed Instance Groups - MIGs). Cuando la carga aumenta, el balanceador detecta el aumento y el MIG automáticamente crea nuevas VMs para manejar el tráfico. Cuando la carga disminuye, las VMs se eliminan para ahorrar costos.🌐 Tipos Principales de Load Balancer en GCPGCP ofrece varios tipos, clasificados según la Capa OSI en la que operan y su Alcance (Global o Regional).A. Según la Capa OSITipoCapaProtocolosUso ComúnHTTP(S) / Externo (L7)Capa 7 (Aplicación)HTTP, HTTPS, HTTP/2Ideal para aplicaciones web globales. Puede inspeccionar la URL y usa funciones avanzadas como el caché (Cloud CDN). Es global.TCP/UDP (L4)Capa 4 (Transporte)TCP, UDP, SSLPara aplicaciones que no son web, tráfico de juegos o protocolos personalizados. Es más rápido que el L7, ya que no inspecciona el contenido de la solicitud. Puede ser global o regional.Balanceador de Carga de Red de Paso (Network TCP/UDP Load Balancing)Capa 4 (Transporte)TCP, UDPUn balanceador passthrough (de paso) que reenvía el paquete de red directamente a los backends. Se usa para preservar la IP de origen del cliente. Es regional.B. Según el AlcanceBalanceador de Carga Global:Distribuye el tráfico a través de múltiples regiones de GCP.Utiliza la red troncal de Google para enrutar el tráfico al backend regional más cercano al usuario, minimizando la latencia.Ejemplo: Balanceador de Carga HTTP(S) Externo.Balanceador de Carga Regional:Distribuye el tráfico solo a los backends dentro de una única región o zona.Ejemplo: Balanceador de Carga TCP/UDP Interno.💡 Beneficios de su UsoUtilizar un balanceador de carga no es solo por distribución; es la base para una arquitectura moderna y robusta:Alta Disponibilidad y Tolerancia a Fallos: Si un servidor o incluso una zona de una región cae, el balanceador redirige automáticamente el tráfico a los servidores sanos restantes.Escalabilidad: Permite manejar picos de tráfico al escalar horizontalmente (añadiendo más servidores) de forma automática.Latencia Mínima: Los balanceadores de carga globales envían a los usuarios al centro de datos más cercano geográficamente, mejorando la experiencia del usuario.Seguridad (WAF): Los Balanceadores de Carga HTTP(S) externos pueden integrarse con Cloud Armor para proporcionar seguridad perimetral (Web Application Firewall).












* Default namespace.
* Deploy using Kubectl cli



