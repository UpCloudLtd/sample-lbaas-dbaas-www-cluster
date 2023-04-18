
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

output "redis_host" {
  value = module.upcloud_dbaas.redis_host
}
output "redis_db_name" {
  value = module.upcloud_dbaas.redis_db_name
}
output "redis_user" {
  value = module.upcloud_dbaas.redis_user
}
output "redis_pass" {
  value = nonsensitive(module.upcloud_dbaas.redis_pass)
}
output "lb_hostname" {
  value = module.upcloud_lbaas.lbaas_hostname
}

output "bastion_host" {
  value = module.upcloud_base.jump_host
}
