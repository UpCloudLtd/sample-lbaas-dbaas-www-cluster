output "nas_ip" {
  value = upcloud_server.nas.network_interface[1].ip_address
}

