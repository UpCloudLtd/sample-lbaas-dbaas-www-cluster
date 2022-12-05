output "dbaas_host" {
  value = module.upcloud_dbaas.dbaas_host
}
output "dbaas_db_name" {
  value = module.upcloud_dbaas.dbaas_db_name
}
output "dbaas_user" {
  value = module.upcloud_dbaas.dbaas_user
}
output "dbaas_pass" {
  value = nonsensitive(module.upcloud_dbaas.dbaas_pass)
}

output "lb_hostname" {
  value = module.upcloud_lbaas.lbaas_hostname
}