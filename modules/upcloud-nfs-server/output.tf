output "nas_ip" {
  value = upcloud_server.nas.network_interface[1].ip_address
}

output "nas_sdn" {
  value = upcloud_network.nas_sdn_network.id
}