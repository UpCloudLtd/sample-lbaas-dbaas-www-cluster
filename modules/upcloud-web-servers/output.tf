output "web_info" {
  value = [upcloud_server.web[0].network_interface[3].ip_address, upcloud_server.web[1].network_interface[3].ip_address]
}
output "lb_sdn" {
  value = upcloud_network.lb_sdn_network.id
}