# Resource Block: Create a Compute Engine instance
resource "google_compute_instance" "myapp1" {
  # Meta-Argument: count
  # por default se crea solo una instancia del recurso
  # creara el numero de instancias de vm segun lo indicado en el atributo COUNT
  # en este caso creara 2 instancias del recurso donde fue definido
  # el argumento count.index le asignara un idex unico comenzando en 0
  # para count = 2 --- 0,1
  count = 2
  name         = "myapp1-vm-${count.index}"
  machine_type = var.machine_type
  zone         = "us-central1-a"
  tags        = [tolist(google_compute_firewall.fw_ssh.target_tags)[0], tolist(google_compute_firewall.fw_http.target_tags)[0]]
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
    }
  }
  # Install Webserver
  metadata_startup_script = file("${path.module}/app1-webserver-install.sh")
  network_interface {
    subnetwork = google_compute_subnetwork.mysubnet.id   
    access_config {
      # Include this section to give the VM an external IP address
    }
  }
}