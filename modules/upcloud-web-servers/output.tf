output "web_info" {
  value = [upcloud_server.web[0].network_interface[2].ip_address, upcloud_server.web[1].network_interface[2].ip_address]
}