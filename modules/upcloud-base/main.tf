
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

resource "upcloud_firewall_rules" "jumphost_fw" {
  server_id = upcloud_server.jumphost.id
  firewall_rule {
    action               = "accept"
    direction            = "in"
    family               = "IPv6"
    protocol             = "tcp"
    source_address_end   = "2a04:3540:53::1"
    source_address_start = "2a04:3540:53::1"
    source_port_end      = "53"
    source_port_start    = "53"
  }

  firewall_rule {
    action               = "accept"
    direction            = "in"
    family               = "IPv6"
    protocol             = "udp"
    source_address_end   = "2a04:3540:53::1"
    source_address_start = "2a04:3540:53::1"
    source_port_end      = "53"
    source_port_start    = "53"
  }

  firewall_rule {
    action               = "accept"
    direction            = "in"
    family               = "IPv6"
    protocol             = "tcp"
    source_address_end   = "2a04:3544:53::1"
    source_address_start = "2a04:3544:53::1"
    source_port_end      = "53"
    source_port_start    = "53"
  }

  firewall_rule {
    action               = "accept"
    direction            = "in"
    family               = "IPv6"
    protocol             = "udp"
    source_address_end   = "2a04:3544:53::1"
    source_address_start = "2a04:3544:53::1"
    source_port_end      = "53"
    source_port_start    = "53"
  }

  firewall_rule {
    action               = "accept"
    direction            = "in"
    family               = "IPv4"
    protocol             = "udp"
    source_address_end   = "94.237.127.9"
    source_address_start = "94.237.127.9"
    source_port_end      = "53"
    source_port_start    = "53"
  }

  firewall_rule {
    action               = "accept"
    direction            = "in"
    family               = "IPv4"
    protocol             = "tcp"
    source_address_end   = "94.237.127.9"
    source_address_start = "94.237.127.9"
    source_port_end      = "53"
    source_port_start    = "53"
  }

  firewall_rule {
    action               = "accept"
    direction            = "in"
    family               = "IPv4"
    protocol             = "udp"
    source_address_end   = "94.237.40.9"
    source_address_start = "94.237.40.9"
    source_port_end      = "53"
    source_port_start    = "53"
  }

  firewall_rule {
    action               = "accept"
    direction            = "in"
    family               = "IPv4"
    protocol             = "tcp"
    source_address_end   = "94.237.40.9"
    source_address_start = "94.237.40.9"
    source_port_end      = "53"
    source_port_start    = "53"
  }

  firewall_rule {
    action                 = "accept"
    comment                = "Allow SSH "
    destination_port_end   = "22"
    destination_port_start = "22"
    direction              = "in"
    family                 = "IPv4"
    protocol               = "tcp"
  }
  firewall_rule {
    action    = "drop"
    direction = "in"
  }
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
