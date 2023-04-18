resource "upcloud_server" "nas" {
  hostname   = "nfs-server"
  zone       = var.zone
  plan       = var.nas_plan
  firewall   = true
  metadata   = true
  depends_on = [var.nas_sdn,var.jump_host]

  template {
    storage = "Ubuntu Server 22.04 LTS (Jammy Jellyfish)"
  }
  network_interface {
    type = "utility"
  }
  network_interface {
    type    = "private"
    network = var.nas_sdn
  }
  network_interface {
    type    = "private"
    network = var.lb_sdn
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
awk 'NR==16{print "            nameservers:\n                addresses: [94.237.127.9,  94.237.40.9]"}1' /etc/netplan/50-cloud-init.yaml > awk_out
cat awk_out > /etc/netplan/50-cloud-init.yaml
netplan apply
export DEBIAN_FRONTEND=noninteractive
apt-get -q -y update
apt-get -o 'Dpkg::Options::=--force-confold' -q -y upgrade
apt-get -o 'Dpkg::Options::=--force-confold' -q -y install nfs-kernel-server
mkdir -p /data
echo '/data         ${var.nas_network}(rw,sync,no_subtree_check,no_root_squash)' >> /etc/exports
chown -R nobody:nogroup /data
exportfs -ar
EOT
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