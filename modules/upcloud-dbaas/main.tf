resource "upcloud_managed_database_mysql" "dbaas_mysql" {
  name = "demo-mysql-dbaas"
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

resource "upcloud_managed_database_redis" "dbaas_redis" {
  name = "demo-redis-dbaas"
  plan = var.redis_plan
  zone = var.zone
}

