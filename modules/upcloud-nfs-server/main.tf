
resource "upcloud_network" "nas_sdn_network" {
  name = "nas-network"
  zone = var.zone

  ip_network {
    address            = var.nas_network
    dhcp               = true
    dhcp_default_route = false
    family             = "IPv4"
  }
}


resource "upcloud_server" "nas" {
  hostname   = "nfs-server"
  zone       = var.zone
  plan       = var.nas_plan
  firewall   = true
  metadata   = true
  depends_on = [upcloud_network.nas_sdn_network]

  template {
    storage = "Ubuntu Server 22.04 LTS (Jammy Jellyfish)"
  }
  network_interface {
    type = "public"
  }
  network_interface {
    type    = "private"
    network = upcloud_network.nas_sdn_network.id
  }
  login {
    user = "root"
    keys = [
      var.ssh_key_public,
    ]
    create_password   = false
    password_delivery = "email"
  }

  connection {
    host  = self.network_interface[0].ip_address
    type  = "ssh"
    user  = "root"
    agent = true
  }

  provisioner "remote-exec" {
    inline = [
      "apt-get -y update",
      "apt-get -y install nfs-kernel-server",
      "mkdir -p /data",
      "echo '/data         10.20.0.0/24(rw,sync,no_subtree_check,no_root_squash)' >> /etc/exports",
      "chown -R nobody:nogroup /data",
      "exportfs -ar"
    ]
  }
}

resource "upcloud_firewall_rules" "nas_fw" {
  server_id = upcloud_server.nas.id
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
}