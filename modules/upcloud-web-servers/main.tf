

resource "upcloud_server" "web" {
  hostname   = "web-server-${count.index}"
  zone       = var.zone
  count      = 2
  plan       = var.www_plan
  metadata   = true
  depends_on = [var.nas_sdn, var.lb_sdn, var.jump_host]

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
awk 'NR==16{print "            nameservers:\n                addresses: [94.237.127.9,  94.237.40.9]"}1' /etc/netplan/50-cloud-init.yaml > netplan_out
cat netplan_out > /etc/netplan/50-cloud-init.yaml
netplan apply
export DEBIAN_FRONTEND=noninteractive
apt update
apt-get -o 'Dpkg::Options::=--force-confold' -q -y upgrade
apt-get -o 'Dpkg::Options::=--force-confold' -q -y install apache2 php php-mysql php-xml php-mbstring libapache2-mod-php php-common nfs-client nfs-common
mkdir -p /var/www/data
mount ${var.nas_ip}:/data /var/www/data
echo "${var.nas_ip}:/data /var/www/data nfs auto,nofail,noatime,nodiratime,nolock,rsize=1048576,wsize=1048576 0 0" >> /etc/fstab
sed -i 's/DocumentRoot \/var\/www\/html/DocumentRoot \/var\/www\/data/g' /etc/apache2/sites-enabled/000-default.conf
chown -R www-data:www-data /var/www/data
echo "<?php phpinfo(); ?>" > /var/www/data/index.php
systemctl restart apache2
EOT
}

resource "upcloud_server_group" "web-ha-pair" {
  title         = "web_ha_group"
  anti_affinity = true
  labels = {
    "key1" = "web-ha"

  }
  members = [
    upcloud_server.web[0].id,
    upcloud_server.web[1].id
  ]

}


resource "upcloud_firewall_rules" "web_fw" {
  count     = 2
  server_id = upcloud_server.web["${count.index}"].id
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

