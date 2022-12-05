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