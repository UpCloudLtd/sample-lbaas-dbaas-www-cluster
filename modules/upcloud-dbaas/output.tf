output "dbaas_host" {
  value = upcloud_managed_database_mysql.dbaas_mysql.service_host
}

output "dbaas_db_name" {
  value = upcloud_managed_database_logical_database.websitedb.name
}

output "dbaas_user" {
  value = upcloud_managed_database_user.websiteuser.username
}
output "dbaas_pass" {
  value = upcloud_managed_database_user.websiteuser.password
}

output "redis_host" {
  value = upcloud_managed_database_redis.dbaas_redis.service_host
}

output "redis_db_name" {
  value = upcloud_managed_database_redis.dbaas_redis.primary_database
}

output "redis_user" {
  value = upcloud_managed_database_redis.dbaas_redis.service_username
}
output "redis_pass" {
  value = upcloud_managed_database_redis.dbaas_redis.service_password
}