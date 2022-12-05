module "upcloud_dbaas" {
  source     = "./modules/upcloud-dbaas"
  zone       = var.zone
  dbaas_plan = var.dbaas_plan
}
module "upcloud_nfs_server" {
  source         = "./modules/upcloud-nfs-server"
  ssh_key_public = var.ssh_key_public
  zone           = var.zone
  nas_plan       = var.nas_plan
  nas_network    = var.nas_network
}

module "upcloud_www_servers" {
  source         = "./modules/upcloud-web-servers"
  ssh_key_public = var.ssh_key_public
  zone           = var.zone
  www_plan       = var.www_plan
  nas_sdn        = module.upcloud_nfs_server.nas_sdn
  nas_ip         = module.upcloud_nfs_server.nas_ip
  lb_network     = var.lb_network
}

module "upcloud_lbaas" {
  source     = "./modules/upcloud-lbaas"
  zone       = var.zone
  lbaas_plan = var.lbaas_plan
  web_info   = module.upcloud_www_servers.web_info
  lb_sdn     = module.upcloud_www_servers.lb_sdn
}
