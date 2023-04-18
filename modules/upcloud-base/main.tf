
resource "upcloud_server" "jumphost" {
  hostname   = "jumphost-server"
  zone       = var.zone
  plan       = "1xCPU-1GB"
  firewall   = true
  metadata   = true

  template {
    storage = "Ubuntu Server 22.04 LTS (Jammy Jellyfish)"
  }
  network_interface {
    type = "public"
  }
  network_interface {
    type    = "utility"
  }
  login {
    user = "root"
    keys = [
      var.ssh_key_public,
    ]
    create_password   = false
    password_delivery = "email"
  }
  user_data = <<-EOT
#!/bin/bash
export DEBIAN_FRONTEND=noninteractive
apt update
apt-get -o 'Dpkg::Options::=--force-confold' -q -y upgrade
EOT
}

resource "upcloud_router" "gateway" {
  name = "nat-gw-router"
}

resource "upcloud_network" "nas_sdn_network" {
  name = "nas-network"
  zone = var.zone

  ip_network {
    address            = var.nas_network
    dhcp               = true
    dhcp_default_route = true
    family             = "IPv4"
  }
  router = upcloud_router.gateway.id
}

resource "upcloud_network" "lb_sdn_network" {
  name = "lb-network"
  zone = var.zone
  ip_network {
    address            = var.lb_network
    dhcp               = true
    dhcp_default_route = false
    family             = "IPv4"
  }

}

resource "upcloud_gateway" "nat-gateway" {
  name     = "nat-gw"
  zone     = var.zone
  features = ["nat"]

  router {
    id = upcloud_router.gateway.id
  }
}