output "jump_host" {
  value = upcloud_server.jumphost.network_interface[0].ip_address
}
output "nas_sdn" {
  value = upcloud_network.nas_sdn_network.id
}
output "lb_sdn" {
  value = upcloud_network.lb_sdn_network.id
}
output "db_sdn" {
  value = upcloud_network.db_sdn_network.id
}