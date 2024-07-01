
resource "upcloud_loadbalancer" "main" {
  configured_status = "started"
  name              = "www-cluster-lb"
  plan              = var.lbaas_plan
  zone              = var.zone
  networks {
    name    = "SDN-Network"
    family  = "IPv4"
    type    = "private"
    network = var.lb_sdn
  }
  networks {
    name   = "Public-Network"
    type   = "public"
    family = "IPv4"
  }
  depends_on = [var.lb_sdn]
}

resource "upcloud_loadbalancer_backend" "main" {
  loadbalancer = upcloud_loadbalancer.main.id
  name         = "main"
}

resource "upcloud_loadbalancer_static_backend_member" "main" {
  depends_on   = [var.web_info]
  count        = 2
  backend      = upcloud_loadbalancer_backend.main.id
  name         = "member_${count.index}"
  ip           = var.web_info["${count.index}"]
  port         = 80
  max_sessions = 1000
  enabled      = true
  weight       = 100
}

resource "upcloud_loadbalancer_frontend" "main" {
  loadbalancer = upcloud_loadbalancer.main.id
  name         = "main"
  mode         = "http"
  port         = 80
  networks {
    name = upcloud_loadbalancer.main.networks[1].name
  }

  default_backend_name = upcloud_loadbalancer_backend.main.name
}