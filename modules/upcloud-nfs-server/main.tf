resource "upcloud_server" "nas" {
  hostname   = "nfs-server"
  zone       = var.zone
  plan       = var.nas_plan
  firewall   = true
  metadata   = true
  depends_on = [var.nas_sdn, var.jump_host]

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
