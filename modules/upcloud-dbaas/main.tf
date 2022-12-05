resource "upcloud_managed_database_mysql" "dbaas_mysql" {
  name = "mysql-dbaas"
  plan = var.dbaas_plan
  zone = var.zone
}

resource "upcloud_managed_database_logical_database" "websitedb" {
  service = upcloud_managed_database_mysql.dbaas_mysql.id
  name    = "website"
}

resource "upcloud_managed_database_user" "websiteuser" {
  service  = upcloud_managed_database_mysql.dbaas_mysql.id
  username = "webadmin"
}